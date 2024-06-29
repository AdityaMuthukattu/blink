import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: AppViewModel
    @EnvironmentObject var globalState: GlobalState
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Eye Break Reminder")
                .font(.title)
                .padding()
            
            Text("Total Breaks Completed: \(globalState.totalBreaksCompleted)")

            Button(action: { viewModel.showBreakWindow = true }) {
                Text("Start Break")
                    .padding()
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .background(Color.blue) // Ensure this matches your UI theme
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
            }
            .buttonStyle(PlainButtonStyle()) // Apply a plain button style to remove any default styling

            Button(action: { viewModel.showSettingsWindow = true }) {
                Text("Settings")
                    .padding()
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .background(Color.gray) // Ensure this matches your UI theme
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
            }
            .buttonStyle(PlainButtonStyle()) // Apply a plain button style here as well
        }
        .padding()
        .sheet(isPresented: $viewModel.showSettingsWindow) {
            SettingsView()
        }
    }
}
