import SwiftUI

import AppKit // For playing sounds
import UserNotifications // For sending notifications

import AVFoundation

var audioPlayer: AVAudioPlayer?

func playChimeSound() {
    guard let soundURL = Bundle.main.url(forResource: "chime", withExtension: "mp3") else {
        print("Unable to locate sound file.")
        return
    }
    do {
        audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
        audioPlayer?.play()
    } catch {
        print("Unable to play the sound file.")
    }
}

func sendBreakFinishedNotification() {
    UNUserNotificationCenter.current().getNotificationSettings { settings in
        guard settings.authorizationStatus == .authorized else {
            print("Notifications are not authorized")
            return
        }

        let content = UNMutableNotificationContent()
        content.title = "Break Finished"
        content.body = "Your break is over. Time to get back to work!"
        content.sound = UNNotificationSound.default

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil) // Trigger now
        UNUserNotificationCenter.current().add(request)
    }
}

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
                                playChimeSound()
                                sendBreakFinishedNotification()
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
