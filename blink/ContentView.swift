import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: AppViewModel
    
    var body: some View {
        VStack {
            Text("Eye Break Reminder")
                .font(.largeTitle)
                .padding()

            Button(action: { viewModel.showBreakWindow = true }) {
                Text("Start Break")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }

            Button(action: { viewModel.showSettingsWindow = true }) {
                Text("Settings")
                    .padding()
                    .background(Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
        .sheet(isPresented: $viewModel.showSettingsWindow) {
            SettingsView()
        }
    }
}
