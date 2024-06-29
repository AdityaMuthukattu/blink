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

            // Display the statistic
            Text(statisticText())
                .padding()
                .textCase(.uppercase)
                .foregroundColor(Color.secondary) // Makes the font color muted
                .font(.system(size: 12)) // Makes the font size a bit smaller
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
func statisticText() -> String {
    // Get the current date's weekday
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE" // Format for full weekday name
    let currentWeekday = dateFormatter.string(from: Date())
    
    // Use the current weekday to fetch data
    guard let lastWeekData = globalState.dataForDay(day: currentWeekday, weeksAgo: 1),
          let currentData = globalState.dataForDay(day: currentWeekday, weeksAgo: 0) else {
        return "Data for last \(currentWeekday) not available."
    }
    
    let percentageDifference = ((currentData - lastWeekData) / lastWeekData) * 100
    let formattedPercentage = String(format: "%.2f", abs(percentageDifference))
    
    if percentageDifference > 0 {
        return "\(formattedPercentage)% higher than ‘\(currentWeekday)’ last week"
    } else if percentageDifference < 0 {
        return "\(formattedPercentage)% lower than ‘\(currentWeekday)’ last week"
    } else {
        return "No change from ‘\(currentWeekday)’ last week"
    }
}
}
