import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: AppViewModel
    @EnvironmentObject var globalState: GlobalState
    private var progress: Float {
        let numBreaksTaken = Float(globalState.totalBreaksCompleted)
        let userBreakFrequency = Float(globalState.breakFrequency)
        let numBreaksRequired = (numBreaksTaken * userBreakFrequency) / 20.0
        return numBreaksTaken / numBreaksRequired
    }

    var body: some View {
        VStack(spacing: 20) {
            Text("Today's Eye Score")
                .font(.title)
                .padding()
            
            ProgressBar(progress: progress)
                .frame(width: 150, height: 150)
                .padding()
            Text("Total Breaks Completed: \(globalState.totalBreaksCompleted)")

            Button(action: { viewModel.showBreakWindow = true }) {
                Text("Start Break")
                    .padding()
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .background(Color.blue)
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
            SettingsView(isPresented: $viewModel.showSettingsWindow)
        }
    }
}
