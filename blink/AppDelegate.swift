import SwiftUI
import AppKit

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?
    var fullScreenWindow: NSWindow?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        setupMenuBar()
        NotificationCenter.default.addObserver(self, selector: #selector(closeBreakWindow), name: NSNotification.Name("CloseBreak"), object: nil)
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
    
    func showFullScreenBreakView() {
        if fullScreenWindow == nil {
            fullScreenWindow = NSWindow(contentRect: NSScreen.main!.frame, styleMask: .borderless, backing: .buffered, defer: false)
            fullScreenWindow?.level = .mainMenu + 1
            fullScreenWindow?.isOpaque = false
            fullScreenWindow?.backgroundColor = .clear
            fullScreenWindow?.contentView = NSHostingView(rootView: FullScreenBreakView())
        }
        fullScreenWindow?.makeKeyAndOrderFront(nil)
    }
    
    @objc func closeBreakWindow() {
        fullScreenWindow?.orderOut(nil)
        fullScreenWindow = nil
    }
}
