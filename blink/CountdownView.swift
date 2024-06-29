//
//  CountdownView.swift
//  blink
//
//  Created by Aditya Muthukattu on 30/6/2024.
//

import SwiftUI
struct CountdownView: View {
    @Binding var isShowing: Bool
    @State private var remainingTime: Int = 5
    @State private var timer: Timer?

    var body: some View {
        ZStack {
            Color.black
                .opacity(0.7)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                ProgressCircle(progress: Double(5 - remainingTime) / 5.0)
                    .frame(width: 200, height: 200)
                    .padding()
                
                Text("\(remainingTime)")
                    .font(.system(size: 100))
                    .foregroundColor(.white)
                    .padding()
            }
        }
        .onAppear {
            startCountdown()
        }
    }
    
    private func startCountdown() {
        timer?.invalidate()
        remainingTime = 5
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if remainingTime > 0 {
                remainingTime -= 1
            } else {
                timer?.invalidate()
                isShowing = false // Hide the countdown when it reaches zero
            }
        }
    }
}

struct ProgressCircle: View {
    var progress: Double
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 10)
                .opacity(0.3)
                .foregroundColor(.white)
            
            Circle()
                .trim(from: 0.0, to: CGFloat(progress))
                .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                .foregroundColor(.white)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.linear(duration: 1.0), value: progress)
        }
    }
}
