//
//  Observations.swift
//  SmartEnergyMonitoring
//
//  Created by Fábio Cordeiro Gaspar on 24/11/2022.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let observations = try? newJSONDecoder().decode(Observations.self, from: jsonData)

import Foundation

struct Observation: Codable {
    let observation: ObservationClass
    let consumption: ConsumptionShort
}

struct ConsumptionShort: Codable {
    let id, userID, observationID: Int
    let value, variance: String
    let timestamp: Int

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case observationID = "observation_id"
        case value, variance, timestamp
    }
}

struct ObservationClass: Codable {
    let id, userID, consumptionID: Int
    let expectedDivisions: [String]
    let createdAt: Int
    let equipments: [EquipmentShort]

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case consumptionID = "consumption_id"
        case expectedDivisions = "expected_divisions"
        case createdAt = "created_at"
        case equipments
    }
}

typealias Observations = [Observation]
