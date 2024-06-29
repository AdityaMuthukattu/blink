import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var viewModel: AppViewModel
    @State private var breakInterval: Double = 20.0

    var body: some View {
        VStack {
            Text("Settings")
                .font(.largeTitle)
                .padding()

            Text("Break Interval: \(Int(breakInterval)) minutes")
            Slider(value: $breakInterval, in: 1...60, step: 1)
                .padding()

            Button(action: {
                viewModel.showSettingsWindow = false
            }) {
                Text("Done")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
    }
}
