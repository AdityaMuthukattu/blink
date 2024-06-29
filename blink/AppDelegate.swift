import SwiftUI
import AppKit

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?
    var fullScreenWindow: NSWindow?
    var fullScreenWindow1: NSWindow? // Added for showBackToWorkView
    var onClose: ((_ breakCompleted: Bool) -> Void)? // Updated callback type
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        setupMenuBar()
        NotificationCenter.default.addObserver(self, selector: #selector(closeBreakWindow), name: NSNotification.Name("CloseBreak"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(cancelBreakEarly), name: NSNotification.Name("CancelBreak"), object: nil)
    }
    
    private func setupMenuBar() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: "clock", accessibilityDescription: "Take a break")
            let menu = NSMenu()
            menu.addItem(NSMenuItem(title: "Take a Break", action: #selector(takeBreak), keyEquivalent: "B"))
            menu.addItem(NSMenuItem(title: "Settings", action: #selector(openSettings), keyEquivalent: ","))
            menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "Q"))
            statusItem?.menu = menu
        }
    }
    
    @objc private func takeBreak() {
        NotificationCenter.default.post(name: NSNotification.Name("TakeBreak"), object: nil)
    }
    
    @objc private func openSettings() {
        NotificationCenter.default.post(name: NSNotification.Name("OpenSettings"), object: nil)
    }
    
    func showFullScreenBreakView(onClose: @escaping (_ breakCompleted: Bool) -> Void) {
        self.onClose = onClose
        if fullScreenWindow == nil {
            fullScreenWindow = NSWindow(contentRect: NSScreen.main!.frame, styleMask: .borderless, backing: .buffered, defer: false)
            fullScreenWindow?.level = .mainMenu + 1
            fullScreenWindow?.isOpaque = false
            fullScreenWindow?.backgroundColor = .clear
            fullScreenWindow?.contentView = NSHostingView(rootView: FullScreenBreakView())
        }
        fullScreenWindow?.makeKeyAndOrderFront(nil)
    }
    
    func showBackToWorkView(onClose: @escaping (_ breakCompleted: Bool) -> Void) {
        self.onClose = onClose
        if fullScreenWindow1 == nil {
            fullScreenWindow1 = NSWindow(contentRect: NSScreen.main!.frame, styleMask: .borderless, backing: .buffered, defer: false)
            fullScreenWindow1?.level = .mainMenu + 1
            fullScreenWindow1?.isOpaque = false
            fullScreenWindow1?.backgroundColor = .clear
            fullScreenWindow1?.contentView = NSHostingView(rootView: BackToWorkView())
        }
        fullScreenWindow1?.makeKeyAndOrderFront(nil)
    }
    
    @objc private func closeBreakWindow() {
        fullScreenWindow?.orderOut(nil)
        fullScreenWindow = nil
        onClose?(true)
        onClose = nil
    }
    
    @objc private func cancelBreakEarly() {
        fullScreenWindow?.orderOut(nil) // Update to fullScreenWindow
        fullScreenWindow = nil
        onClose?(false)
        onClose = nil
    }
}
