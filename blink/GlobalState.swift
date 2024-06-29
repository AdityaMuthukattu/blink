//
//  GlobalState.swift
//  blink
//
//  Created by Monash Sapkota on 29/6/2024.
//

import Foundation
import Combine

class GlobalState: ObservableObject {
    // Screen time tracking
    @Published var consecutiveMinutes: Int = 0
    // Break management
    @Published var totalBreaksPrompted: Int = 0
    @Published var totalBreaksCompleted: Int = 0
    @Published var isBreakActive: Bool = false // To manage break view visibility
    // Break frequency and historical data
    @Published var breakFrequency: Int = 20
    var pathToPastData: String? // Path to save/load historical data
    // Timer to simulate screen time increment, replace or remove with actual logic
    var screenTimeTimer: Timer?
    init() {
        startScreenTimeTracking()
    }
    func startScreenTimeTracking() {
        screenTimeTimer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.consecutiveMinutes += 1
            if self.consecutiveMinutes % self.breakFrequency == 0 {
                self.promptBreak()
            }
        }
    }
    
    func promptBreak() {
        totalBreaksPrompted += 1
        isBreakActive = true // This could trigger showing the break view
    }
    func completeBreak() {
        // Logic to handle break completion
        totalBreaksCompleted += 1
        isBreakActive = false // Hide the break view
        consecutiveMinutes = 0 // Reset screen time or adjust as needed
        saveData()
    }
}

extension GlobalState {
    // Key names for UserDefaults
    private struct UserDefaultsKeys {
        static let consecutiveMinutes = "consecutiveMinutes"
        static let totalBreaksPrompted = "totalBreaksPrompted"
        static let totalBreaksCompleted = "totalBreaksCompleted"
        static let breakFrequency = "breakFrequency"
    }
    
    // Save simple data using UserDefaults
    func saveSimpleData() {
        UserDefaults.standard.set(consecutiveMinutes, forKey: UserDefaultsKeys.consecutiveMinutes)
        UserDefaults.standard.set(totalBreaksPrompted, forKey: UserDefaultsKeys.totalBreaksPrompted)
        UserDefaults.standard.set(totalBreaksCompleted, forKey: UserDefaultsKeys.totalBreaksCompleted)
        UserDefaults.standard.set(breakFrequency, forKey: UserDefaultsKeys.breakFrequency)
    }
    
    // Load simple data from UserDefaults
    func loadSimpleData() {
        consecutiveMinutes = UserDefaults.standard.integer(forKey: UserDefaultsKeys.consecutiveMinutes)
        totalBreaksPrompted = UserDefaults.standard.integer(forKey: UserDefaultsKeys.totalBreaksPrompted)
        totalBreaksCompleted = UserDefaults.standard.integer(forKey: UserDefaultsKeys.totalBreaksCompleted)
        breakFrequency = UserDefaults.standard.integer(forKey: UserDefaultsKeys.breakFrequency)
    }
    
    // Save historical data to a file
    func saveHistoricalData() {

        // Create an instance of DateFormatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let currentDate = dateFormatter.string(from: Date())

        // Use the current date as the key in dictionary
        let dailySummaries = [currentDate: ["breaksPrompted": totalBreaksPrompted, "breaksCompleted": totalBreaksCompleted]]
        if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let filePath = documentDirectory.appendingPathComponent("historicalData.json")
            do {
                let data = try JSONSerialization.data(withJSONObject: dailySummaries, options: [])
                try data.write(to: filePath)
            } catch {
                print("Failed to save historical data: \(error)")
            }
        }
    }
    // Load historical data from a file
    func loadHistoricalData() {
        if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let filePath = documentDirectory.appendingPathComponent("historicalData.json")
            do {
                let data = try Data(contentsOf: filePath)
                if let dailySummaries = try JSONSerialization.jsonObject(with: data, options: []) as? [String: [String: Int]] {
                    print(dailySummaries) // Example usage
                }
            } catch {
                print("Failed to load historical data: \(error)")
            }
        }
    }
    
    // Call this method to save data when app goes to background
    func saveData() {
        saveSimpleData()
        saveHistoricalData()
    }
    
    // Call this method to load data when app starts
    func loadData() {
        loadSimpleData()
        loadHistoricalData()
    }
        // Reset stored values to default
    func resetTodayData() {
        consecutiveMinutes = 0
        totalBreaksPrompted = 0
        totalBreaksCompleted = 0
        breakFrequency = 0 // Assuming 0 is the default value. Adjust as needed.

        // Clear UserDefaults
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.consecutiveMinutes)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.totalBreaksPrompted)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.totalBreaksCompleted)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.breakFrequency)
    }
    
}