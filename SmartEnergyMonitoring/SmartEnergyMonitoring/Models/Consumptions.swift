//
//  Consumptions.swift
//  SmartEnergyMonitoring
//
//  Created by Fábio Cordeiro Gaspar on 24/11/2022.
//

import Foundation

struct Consumptions: Codable {
    let data: [Consumption]
}

struct Consumption: Codable {
    let id, userID: Int
    let observationID: Int?
    var value, variance: String
    let timestamp: Int

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case observationID = "observation_id"
        case value, variance, timestamp
    }
}

struct ConsumptionData: Identifiable {
    let id = UUID()
    let consumption: Double
    let timestamp: Date
    
    init(consumption: String, timestamp: Int) {
        self.consumption = Double(consumption)!
        self.timestamp = Date(timeIntervalSince1970: Double(timestamp))
    }
}

struct ConsumptionInterval: Codable {
    let value: String
    let timestamp: String
    
    func toConsumption() -> Consumption {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = formatter.date(from: self.timestamp) ?? Date.now
        return Consumption(id: 0, userID: 0, observationID: nil, value: self.value, variance: "", timestamp: Int(date.timeIntervalSince1970))
    }
}
