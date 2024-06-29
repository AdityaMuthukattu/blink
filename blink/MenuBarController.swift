//
//  MenuBarController.swift
//  blink
//
//  Created by Aditya Muthukattu on 29/6/2024.
//

import Foundation
import AppKit

class MenuBarController {
    var statusItem: NSStatusItem!
    
    init() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem.button?.title = "Take a Break"
        statusItem.button?.action = #selector(showBreakScreen)
    }
    
    @objc func showBreakScreen() {
            NotificationCenter.default.post(name: .showBreakScreen, object: nil)
        }
}

extension Notification.Name {
    static let showBreakScreen = Notification.Name("showBreakScreen")
}
 
