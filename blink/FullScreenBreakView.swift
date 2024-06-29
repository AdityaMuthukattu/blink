import SwiftUI

struct FullScreenBreakView: View {
    @State private var showButton = false
    @State private var cursorPosition: CGPoint = .zero
    @State private var progress: Double = 0.0
    private let totalTime: Double = 20.0  // Total time in seconds for the progress to reach full
    @State private var timer: Timer?
    @State private var workItem: DispatchWorkItem?

    var body: some View {
        VStack {
            Text("Take a Break!")
                .font(.largeTitle)
                .foregroundColor(.white)
                .padding()
            Text("Look away from the screen and relax your eyes.")
                .foregroundColor(.white)
                .padding()
                .font(.system(.body, design: .default)) // Using the San Francisco font in body style
                .fontWeight(.regular)
            
            VStack {
                ProgressView(value: progress)
                    .progressViewStyle(LinearProgressViewStyle())
            }
            if showButton {
                Button(action: {
                    closeBreak()
                }) {
                    Text("End Break")
                        .padding()
                }
                .buttonStyle(BorderlessButtonStyle())
                .padding(10)
                .foregroundColor(.gray)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.8))
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            resetProgressAndTimer()
            startTimer()
            scheduleCloseBreak()
        }
        .onAppear {
            // Track cursor movement
            NSEvent.addLocalMonitorForEvents(matching: [.mouseMoved]) {
                self.cursorPosition = $0.locationInWindow
                self.showButton = true
                return $0
            }
        }
        .onDisappear {
            timer?.invalidate()
            workItem?.cancel()
        }
    }
    
    func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            if progress < 1.0 {
                withAnimation(.linear(duration: 0.1)) {
                    progress += 0.1 / totalTime
                }
            } else {
                timer?.invalidate()
            }
        }
    }
    
    func closeBreak() {
        timer?.invalidate()
        workItem?.cancel() // Cancel the scheduled task
        NotificationCenter.default.post(name: NSNotification.Name("CloseBreak"), object: nil)
    }
    
    func scheduleCloseBreak() {
        let item = DispatchWorkItem {
            NotificationCenter.default.post(name: NSNotification.Name("CloseBreak"), object: nil)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + totalTime, execute: item)
        workItem = item // Save the work item to be able to cancel it later
    }
    
    func resetProgressAndTimer() {
        progress = 0.0
        timer?.invalidate()
    }
}

struct LinearProgressViewStyle: ProgressViewStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack {
            configuration.label
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: geometry.size.width/3, height: 10)
                        .foregroundColor(Color.gray.opacity(0.3))
                        .offset(x: (geometry.size.width - (geometry.size.width / 3)) / 2)
                    
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: (geometry.size.width/3) * CGFloat(configuration.fractionCompleted ?? 0), height: 10)
                        .foregroundColor(Color.orange)
                        .offset(x: (geometry.size.width - (geometry.size.width / 3)) / 2)
                }
                .animation(.linear, value: configuration.fractionCompleted)
            }
            .frame(height: 10)
        }
    }
}

