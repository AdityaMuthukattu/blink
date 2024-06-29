//
//  GraphView.swift
//  blink
//
//  Created by Monash Sapkota on 30/6/2024.
//

import SwiftUI
import Charts

struct GraphView: View {
    var eyeScores: [EyeScore]

    var body: some View {
        VStack {
            Text("Weekly Eye Score Trend")
                .font(.largeTitle) // Makes the font larger
                .fontWeight(.bold) // Makes the font bold
                .padding(.vertical, 10) // Adds vertical padding
                .padding(.horizontal, 20) // Adds horizontal padding
                .foregroundColor(.secondary) // Changes the text color to secondary
                .cornerRadius(10) // Rounds the corners of the background
                .padding() // Adds more padding around the entire element for spacing
                
            HStack {
                Image(systemName: "chevron.left")
                    .onTapGesture {
                        // Handle left arrow tap, e.g., show previous week
                    }
                Image(systemName: "chevron.right")
                    .onTapGesture {
                        // Handle right arrow tap, e.g., show next week
                    }
            }
                .padding(.leading) // Adjust padding as needed to align with the Chart
                .padding(.vertical, 10) // Adds vertical padding
                .frame(maxWidth: .infinity, alignment: .leading) // Align HStack to the left
            Divider()
            Chart {
                ForEach(eyeScores.indices, id: \.self) { index in
                    BarMark(
                        x: .value("Date", eyeScores[index].date, unit: .day),
                        y: .value("Score", eyeScores[index].score)
                    )
                    .foregroundStyle(eyeScores[index].score > 80 ? .green : eyeScores[index].score > 50 ? .yellow : .red)
                    .annotation(position: .top, alignment: .center) {
                        Text("\(eyeScores[index].score)%")
                            .font(.caption)
                    }
                }
            }
            .chartXAxis {
                AxisMarks(values: .stride(by: .day)) {
                    AxisGridLine()
                    AxisValueLabel(format: .dateTime.weekday(.abbreviated))
                }
            }
            .chartYAxis(.hidden)
            .frame(height: 200)
            .padding()

        }
    }
}
