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
    let value, variance: String
    let timestamp: Int

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case observationID = "observation_id"
        case value, variance, timestamp
    }
}
