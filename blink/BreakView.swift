import SwiftUI

struct BreakView: View {
    var body: some View {
        VStack {
            Text("Take a Break!")
                .font(.largeTitle)
                .foregroundColor(.white)
                .padding()
            Text("Look away from the screen and relax your eyes.")
                .foregroundColor(.white)
                .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.8))
        .edgesIgnoringSafeArea(.all)
    }
}
