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
        VStack(spacing: 10) {
            // Simple Header
            HStack {
                Text("Your Dashboard")
                    .font(.headline)
                    .padding()
                Spacer()
    
                // Settings Button with Gear Icon
                Button(action: { viewModel.showSettingsWindow = true }) {
                    Image(systemName: "gear")
                        .foregroundColor(.white)
                        .imageScale(.large) // Adjust the scale of the image
                        .font(.system(size: 18)) // Specify the font size to make the icon larger
                        .padding(3) // Adjust padding around the icon for better touch area without making it look bulky
                }
                .buttonStyle(PlainButtonStyle()) // Apply plain button style to remove default interaction effects
                .cornerRadius(5) // Optional: Adjust corner radius for the button background
            }
            .cornerRadius(10)
            .padding(.trailing, 10) // Add right padding to the HStack
            .background(Color.secondary.opacity(0.1))

            // Main Content
            ScrollView {
                VStack(spacing: 10) {
                    DayRating(progress: progress)
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
                }
                .padding()
            }
        }
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
            return "Data for last \(currentWeekday) not available"
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
