import SwiftUI

import AppKit // For playing sounds


@main
struct blinkApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var viewModel = AppViewModel()
    @StateObject private var globalState = GlobalState()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
                .environmentObject(globalState)
                .onAppear {
                    NotificationCenter.default.addObserver(forName: NSNotification.Name("TakeBreak"), object: nil, queue: .main) { _ in
                        viewModel.showBreakWindow = true
                    }
                    NotificationCenter.default.addObserver(forName: NSNotification.Name("OpenSettings"), object: nil, queue: .main) { _ in
                        viewModel.showSettingsWindow = true
                    }
                    globalState.loadData() // Load data when the app appears
                }
                .onChange(of: viewModel.showBreakWindow) { show in
                    if show {
                        globalState.totalBreaksPrompted += 1
                        appDelegate.showFullScreenBreakView { breakCompleted in
                            // This block is executed when the break window is closed
                            viewModel.showBreakWindow = false
                            if breakCompleted {
                                globalState.completeBreak()
                            }
                        }
                    } else {
                        appDelegate.closeBreakWindow()
                    }
                }
        }
        .commands {
            CommandGroup(replacing: CommandGroupPlacement.appVisibility) {
                Button("Settings") {
                    viewModel.showSettingsWindow = true
                }
                .keyboardShortcut(",", modifiers: .command)
            }
            CommandMenu("Break") {
                Button("Take a Break") {
                    viewModel.showBreakWindow = true
                }
                .keyboardShortcut("B", modifiers: [.shift, .command])
            }
        }
    }
}
