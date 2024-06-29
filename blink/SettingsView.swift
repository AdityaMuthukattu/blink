import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var viewModel: AppViewModel
    @EnvironmentObject var globalState: GlobalState
    // @State private var breakInterval: Double = UserDefaults.standard.double(forKey: "breakInterval") == 0 ? 20.0 : UserDefaults.standard.double(forKey: "breakInterval")
    // @State private var breakDuration: Double = UserDefaults.standard.double(forKey: "breakDuration") == 0 ? 20.0 : UserDefaults.standard.double(forKey: "breakDuration")
    // @State private var playNotificationSounds: Bool = UserDefaults.standard.bool(forKey: "playNotificationSounds")
    @Binding var isPresented: Bool

//    let breakInterval = Float(globalState.breakFrequency)
//    let breakDuration = Float(globalState.breakDuration)
//    let playNotificationSounds = globalState.playNotificationSounds

    var body: some View {
        Spacer()
        HStack {
            Spacer()
            Form {
                HStack {
                    Text("Break Duration")
                    Slider(value: $globalState.breakLength, in: 20...30, step: 1)
                        .accentColor(.blue)
                        .padding()
                    Text("\(Int(globalState.breakLength)) seconds")
                }
                
                Picker("Select Break Interval", selection: $globalState.breakFrequency) {
                    Text("15 minutes").tag(15)
                    Text("20 minutes").tag(20)
                    Text("25 minutes").tag(25)
                }
                
                Toggle("Play notification sounds", isOn: $globalState.playNotificationSounds)
                
                Button("Reset Today's Data") {
                    globalState.resetTodayData()
                }
                .padding()

                
                // Other settings components
                
                Button("Done") {
                    globalState.saveSettings()
                    isPresented = false
                }
                .keyboardShortcut(.defaultAction)
            }
            Spacer()
        }
        Spacer()
    }
    
    
}
