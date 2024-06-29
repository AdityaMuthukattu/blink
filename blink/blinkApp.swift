import SwiftUI

@main
struct blinkApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var viewModel = AppViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
                .onAppear {
                    NotificationCenter.default.addObserver(forName: NSNotification.Name("TakeBreak"), object: nil, queue: .main) { _ in
                        viewModel.showBreakWindow = true
                    }
                    NotificationCenter.default.addObserver(forName: NSNotification.Name("OpenSettings"), object: nil, queue: .main) { _ in
                        viewModel.showSettingsWindow = true
                    }
                }
                .onChange(of: viewModel.showBreakWindow) { show in
                    if show {
                        appDelegate.showFullScreenBreakView()
                    } else {
                        appDelegate.closeBreakWindow()
                    }
                }
        }
    }
}
