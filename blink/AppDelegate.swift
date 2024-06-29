import SwiftUI
import AppKit

import UserNotifications
class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?
    var fullScreenWindow: NSWindow?
    typealias OnCloseCallback = (_ breakCompleted: Bool) -> Void

    var onClose: OnCloseCallback?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        setupMenuBar()
        // Request notification permission
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Notification permission granted.")
            } else if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            }
        }
        NotificationCenter.default.addObserver(self, selector: #selector(closeBreakWindow), name: NSNotification.Name("CloseBreak"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(cancelBreakEarly), name: NSNotification.Name("CancelBreak"), object: nil)
        if let window = NSApplication.shared.windows.first {
            window.setContentSize(NSSize(width: 400, height: 850)) // Set default size
        }
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
    
    @objc func closeBreakWindow() {
        fullScreenWindow?.orderOut(nil)
        fullScreenWindow = nil
        onClose?(true)
        onClose = nil
    }
    @objc func cancelBreakEarly() {
        fullScreenWindow?.orderOut(nil)
        fullScreenWindow = nil
        onClose?(false)
        onClose = nil
    }
}
