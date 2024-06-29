//
//  ProgressBar.swift
//  blink
//
//  Created by Monash Sapkota on 30/6/2024.
//

import Foundation
import SwiftUI

struct DayRating: View {
    var progress: Float
    
    // Computed property to determine color based on progress or NaN
    private var progressColor: Color {
        if progress.isNaN {
            return .gray // Return gray if progress is NaN
        } else {
            switch progress {
            case 0..<0.45:
                return .red
            case 0.45..<0.85:
                return .yellow
            default:
                return .green
            }
        }
    }
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 20.0)
                .opacity(0.3)
                .foregroundColor(progressColor.opacity(0.3)) // Use the computed color with reduced opacity for background
            
            Circle()
                .trim(from: 0.0, to: CGFloat(min(self.progress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(progressColor) // Use the computed color
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.linear, value: progress)
            
            VStack {
                Text("EYE SCORE")
                    .font(.caption)
                    .bold()
                if progress.isNaN {
                    Text("-") // Display '-' if progress is NaN
                        .font(.largeTitle)
                } else {
                    Text(String(format: "%.0f %%", min(self.progress, 1.0)*100.0))
                        .font(.largeTitle)
                        .bold()
                }
            }
        }
    }
}
