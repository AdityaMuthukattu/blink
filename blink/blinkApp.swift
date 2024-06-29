//
//  blinkApp.swift
//  blink
//
//  Created by Aditya Muthukattu on 29/6/2024.
//

import SwiftUI
import AppKit

@main
struct blinkApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?

    func applicationDidFinishLaunching(_ notification: Notification) {
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

    @objc func takeBreak() {
        let blurWindow = NSWindow(contentRect: NSScreen.main!.frame,
                                  styleMask: [.borderless],
                                  backing: .buffered,
                                  defer: false)
        blurWindow.isOpaque = false
        blurWindow.backgroundColor = .clear
        blurWindow.level = .mainMenu + 1
        blurWindow.makeKeyAndOrderFront(nil)

        let blurView = NSVisualEffectView(frame: blurWindow.contentView!.bounds)
        blurView.autoresizingMask = [.width, .height]
        blurView.blendingMode = .behindWindow
        blurView.material = .fullScreenUI
        blurView.state = .active
        blurWindow.contentView?.addSubview(blurView)

        let hostingController = NSHostingController(rootView: BreakView())
        hostingController.view.frame = blurWindow.contentView!.bounds
        hostingController.view.autoresizingMask = [.width, .height]
        blurWindow.contentView?.addSubview(hostingController.view)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            blurWindow.close()
        }
    }

    @objc func openSettings() {
        NSApp.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil)
    }
}
