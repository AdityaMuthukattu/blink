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
                .font(.title) // Makes the font larger
                .fontWeight(.bold) // Makes the font bold
                .padding(.vertical, 10) // Adds vertical padding
                .padding(.horizontal, 20) // Adds horizontal padding
                .foregroundColor(.secondary) // Changes the text color to secondary
                .cornerRadius(10) // Rounds the corners of the background
                
                
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
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    
            }
                .padding(.leading) // Adjust padding as needed to align with the Chart
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
                

        
                 RuleMark(
                     y: .value("Average Score", averageScore)
                 )
                 .annotation(position: .top, alignment: .leading) {
                     Text("Avg: \(averageScore, specifier: "%.0f")%")
                         .font(.caption2)
                         .foregroundColor(.gray)
                         .opacity(0.8)
                 }
                 .lineStyle(StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
                                 .foregroundStyle(Color.gray)
                                 .opacity(0.7)
                                 
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
