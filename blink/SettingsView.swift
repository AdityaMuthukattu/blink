import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var viewModel: AppViewModel
    @EnvironmentObject var globalState: GlobalState
    @State private var breakInterval: Double = UserDefaults.standard.double(forKey: "breakInterval") == 0 ? 20.0 : UserDefaults.standard.double(forKey: "breakInterval")
    @State private var breakDuration: Double = UserDefaults.standard.double(forKey: "breakDuration") == 0 ? 20.0 : UserDefaults.standard.double(forKey: "breakDuration")
    @State private var playNotificationSounds: Bool = UserDefaults.standard.bool(forKey: "playNotificationSounds")
    @Binding var isPresented: Bool
    
    var body: some View {
        Spacer()
        HStack {
            Spacer()
            Form {
                HStack {
                    Text("Break Duration")
                    Slider(value: $breakDuration, in: 20...30, step: 1)
                        .accentColor(.blue)
                        .padding()
                    Text("\(Int(breakDuration)) seconds")
                }
                
                Picker("Select Break Interval", selection: $breakInterval) {
                    Text("15 minutes").tag(15.0)
                    Text("20 minutes").tag(20.0)
                    Text("25 minutes").tag(25.0)
                }
                
                Toggle("Play notification sounds", isOn: $playNotificationSounds)
                
                Button("Reset Today's Data") {
                    globalState.resetTodayData()
                }
                .padding()

                
                // Other settings components
                
                Button("Done") {
                    saveSettings()
                    isPresented = false
                }
                .keyboardShortcut(.defaultAction)
            }
            Spacer()
        }
        Spacer()
    }
    
    private func saveSettings() {
            UserDefaults.standard.set(breakInterval, forKey: "breakInterval")
            UserDefaults.standard.set(breakDuration, forKey: "breakDuration")
            UserDefaults.standard.set(playNotificationSounds, forKey: "playNotificationSounds")
        }
    
}
