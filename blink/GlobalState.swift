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
    var defaultBreakFrequency = 20
    @Published var breakFrequency: Int = 20 // in minutes
    @Published var breakLength: Float = 20.0 // in seconds
    @Published var playNotificationSounds: Bool = false // chime at end of breaks
    
    @Published var historicalData: [String: [String: Int]] = [:]
    var pathToPastData: String? // Path to save/load historical data
    // Timer to simulate screen time increment, replace or remove with actual logic
    var screenTimeTimer: Timer?
    init() {
        startScreenTimeTracking()
        initializePathToPastData()
        generateMockHistoricalData()
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
        static let breakLength = "breakLength"
        static let playNotificationSounds = "playNotificationSounds"
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
        // Retrieve breakFrequency from UserDefaults
        var breakFrequency = UserDefaults.standard.integer(forKey: UserDefaultsKeys.breakFrequency)
        // Guarantee that breakFrequency is never 0 by setting a default value if it is 0
        if breakFrequency == 0 {
            breakFrequency = defaultBreakFrequency
        }
    }
    // Save historical data to a file
    func saveHistoricalData() {
        // Ensure pathToPastData is initialized and not nil
        guard let pathToPastData = self.pathToPastData else {
            print("Path to past data is not set.")
            return
        }
        let fileURL = URL(fileURLWithPath: pathToPastData)
        var existingData: [String: [String: Int]] = [:]
        // Attempt to load existing data
        do {
            let data = try Data(contentsOf: fileURL)
            existingData = try JSONSerialization.jsonObject(with: data, options: []) as? [String: [String: Int]] ?? [:]
        } catch {
            print("Could not load existing data, starting fresh: \(error)")
        }
        // Create an instance of DateFormatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let currentDate = dateFormatter.string(from: Date())

        // Update the existing data with new entry for today
        existingData[currentDate] = ["totalBreaksPrompted": totalBreaksPrompted, "totalBreaksCompleted": totalBreaksCompleted]
        // Save the updated data back to the file
        do {
            let updatedData = try JSONSerialization.data(withJSONObject: existingData, options: [])
            try updatedData.write(to: fileURL)
        } catch {
            print("Failed to save historical data: \(error)")
        }
    }
    // Load historical data from a file
    func loadHistoricalData() {
        // Ensure pathToPastData is initialized and not nil
        guard let pathToPastData = self.pathToPastData else {
            print("Path to past data is not set.")
            return
        }
        
        let fileURL = URL(fileURLWithPath: pathToPastData)
        
        do {
            let data = try Data(contentsOf: fileURL)
            if var dailySummaries = try JSONSerialization.jsonObject(with: data, options: []) as? [String: [String: Int]] {
                // Get today's date as a String
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let today = dateFormatter.string(from: Date())
                
                // Check if the key for today's date exists, if not, create it with 0, 0 values
                if dailySummaries[today] == nil {
                    dailySummaries[today] = ["totalBreaksPrompted": 0, "totalBreaksCompleted": 0]
                }
                
                // Store the updated or original data into the historicalData property
                self.historicalData = dailySummaries
            }
        } catch {
            print("Failed to load historical data: \(error)")
        }
    }
    // Call this method to save data when app goes to background
    func saveData() {
        saveSimpleData()
        saveHistoricalData()
    }
    // Call this method to load data when app starts
    func loadData() {
        print("Before loading data: \(historicalData)")
        loadSimpleData()
        loadHistoricalData()
        print("After loading data: \(historicalData)")
    }
        // Reset stored values to default
    func resetTodayData() {
        consecutiveMinutes = 0
        totalBreaksPrompted = 0
        totalBreaksCompleted = 0

        // Clear UserDefaults
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.consecutiveMinutes)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.totalBreaksPrompted)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.totalBreaksCompleted)
    }

    func dataForDay(day: String, weeksAgo: Int) -> Float? {
        print("Current historicalData: \(historicalData)")
        let calendar = Calendar.current

        // Calculate the number of days to subtract
        let daysAgo = weeksAgo * 7
        // Subtract the days from today's date
        guard let targetDate = calendar.date(byAdding: .day, value: -daysAgo, to: Date()) else {
            return nil
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: targetDate)
        // Access the specific value within the dictionary
        if let numerator = historicalData[dateString]?["totalBreaksCompleted"],
           let denominator = historicalData[dateString]?["totalBreaksPrompted"],
           denominator != 0 {
            return Float(numerator) / Float(denominator)
        } else {
            return nil
        }
    }
    func generateMockHistoricalData() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var mockData: [String: [String: Int]] = [:]

        for dayOffset in 1...7 {
            guard let date = Calendar.current.date(byAdding: .day, value: -dayOffset, to: Date()) else { continue }
            let dateString = dateFormatter.string(from: date)
            // Generate random data for breaksPrompted and breaksCompleted
            let breaksPrompted = Int.random(in: 1...5)
            let breaksCompleted = Int.random(in: 0...breaksPrompted)
            mockData[dateString] = ["totalBreaksPrompted": breaksPrompted, "totalBreaksCompleted": breaksCompleted]
        }

        // Ensure pathToPastData is initialized and not nil
        guard let pathToPastData = self.pathToPastData else {
            print("Path to past data is not set.")
            return
        }

        let fileURL = URL(fileURLWithPath: pathToPastData)

        do {
            let data = try JSONSerialization.data(withJSONObject: mockData, options: [])
            try data.write(to: fileURL)
            print("Mock data successfully saved.")
        } catch {
            print("Failed to save mock data: \(error)")
        }
    }
    func initializePathToPastData() {
        let fileManager = FileManager.default
        do {
            // Get the Application Support directory for the current user
            let appSupportURL = try fileManager.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            
            // Create a subdirectory for your app if it doesn't already exist
            let appDirectoryURL = appSupportURL.appendingPathComponent("Blink", isDirectory: true)
            if !fileManager.fileExists(atPath: appDirectoryURL.path) {
                try fileManager.createDirectory(at: appDirectoryURL, withIntermediateDirectories: true, attributes: nil)
            }
            
            // Specify the filename for your historical data
            let dataFileURL = appDirectoryURL.appendingPathComponent("HistoricalData.json")
            
            // Set the path to the historical data file
            pathToPastData = dataFileURL.path
        } catch {
            print("Failed to initialize path to past data: \(error)")
            pathToPastData = nil
        }
    }
    
    func saveSettings(){
        UserDefaults.standard.set(breakFrequency, forKey: "breakFrequency")
        UserDefaults.standard.set(breakLength, forKey: "breakLength")
        UserDefaults.standard.set(playNotificationSounds, forKey: "playNotificationSounds")
    }

}
