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
    // 1. Calculate the average score
    var averageScore: Double {
        let totalScore = eyeScores.reduce(0) { $0 + $1.score }
        return Double(totalScore) / Double(eyeScores.count)
    }
    let currentDate = Date()
    let sevenDaysAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date())!

    // Computed properties for formatted dates
    private var formattedCurrentDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy" // Example format: Jan 1, 2023
        return dateFormatter.string(from: Date())
    }

    private var formattedSevenDaysAgo: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy" // Example format: Jan 1, 2023
        let sevenDaysAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
        return dateFormatter.string(from: sevenDaysAgo)
    }
    

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
                
                Divider()
            HStack {
                Image(systemName: "chevron.left")
                    .onTapGesture {
                        // Handle left arrow tap, e.g., show previous week
                    }
                Image(systemName: "chevron.right")
                    .onTapGesture {
                        // Handle right arrow tap, e.g., show next week
                    }

                Text("\(formattedSevenDaysAgo) - \(formattedCurrentDate)")
                    .font(.caption)
                    .fontWeight(.bold) // Makes the font bold
                    .padding(.horizontal, 20) // Adjust padding as needed
                    .padding(.vertical, 10)
                    
            }
                .padding(.leading) // Adjust padding as needed to align with the Chart
                .padding(.vertical, 10) // Adds vertical padding
                .frame(maxWidth: .infinity, alignment: .leading) // Align HStack to the left
            Text("Avg: \(String(format: "%.1f", averageScore))%")
                .font(.caption)
                .foregroundColor(.blue)
                .padding(.leading, 20) // Adjust padding as needed for alignment
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
                // 2. Add an AverageLine to the Chart
                RuleMark(
                    y: .value("Average Score", averageScore)
                )
                .lineStyle(StrokeStyle(lineWidth: 1, dash: [5]))
                .foregroundStyle(.blue)
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
