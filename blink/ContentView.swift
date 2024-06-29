import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: AppViewModel
    @EnvironmentObject var globalState: GlobalState
    private var progress: Float {
        let numBreaksTaken = Float(globalState.totalBreaksPrompted)
        let breaksCompleted = Float(globalState.totalBreaksCompleted)
        let userBreakFrequency = Float(globalState.breakFrequency)
        let numBreaksRequired = (numBreaksTaken * userBreakFrequency) / 20.0
        return breaksCompleted / numBreaksRequired
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
                        .foregroundColor(Color.secondary)
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
                    // Display the statistic
                    Text("Today's Score")
                        .font(.largeTitle) // Makes the font larger
                        .fontWeight(.bold) // Makes the font bold
                        .foregroundColor(.secondary)
                    
                    Spacer(minLength: 5)
                    DayRating(progress: progress)
                        .frame(width: 200, height: 200)
                        .padding()
                    Spacer(minLength: 5)
                    if (globalState.totalBreaksCompleted == 1) {
                        Text("You have taken \(globalState.totalBreaksCompleted) break today!")
                            .foregroundColor(Color.secondary)
                            .font(.system(size: 12))
                    } else {
                        Text("You have taken \(globalState.totalBreaksCompleted) breaks today!")
                            .foregroundColor(Color.secondary)
                            .font(.system(size: 12))
                    }
                    Text(statisticText())
                        .foregroundColor(Color.secondary) // Makes the font color muted
                        .font(.system(size: 12)) // Makes the font size a bit smaller
                        .padding()
                    

                    Spacer(minLength: 50)

                    GraphView(eyeScores: globalState.eyeScores)
                        .frame(height: 200)
                        .padding(.bottom, 50) // Increase bottom padding to 50
                }
                .padding()
            }
        }
        .sheet(isPresented: $viewModel.showSettingsWindow) {
            SettingsView(isPresented: $viewModel.showSettingsWindow)
        }.scrollDisabled(true)
    }
    func statisticText() -> String {
        // Get the current date's weekday
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE" // Format for full weekday name
        let currentWeekday = dateFormatter.string(from: Date())
        
        // Use the current weekday to fetch data
        guard let lastWeekData = globalState.dataForDay(day: currentWeekday, weeksAgo: 1) else {
            return "Data for last \(currentWeekday) not available"
        }
        print(progress)
        var percentageDifference: Float = 100.0
        if lastWeekData != 0 {
            percentageDifference = ((progress - lastWeekData) /  lastWeekData) * 100
        }
        let formattedPercentage = String(format: "%.2f", abs(percentageDifference))
        
        if percentageDifference > 0 {
            return "That's \(formattedPercentage)% higher than \(currentWeekday) last week!"
        } else if percentageDifference < 0 {
            return "That's \(formattedPercentage)% lower than \(currentWeekday) last week"
        } else {
            return "No change from \(currentWeekday) last week"
        }
    }
}
