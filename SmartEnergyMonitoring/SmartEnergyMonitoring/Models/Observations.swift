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
    var observation: ObservationClass
    var consumption: ConsumptionShort
}

struct ConsumptionShort: Codable {
    var id, userID, observationID: Int
    var value, variance: String
    var timestamp: Int

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case observationID = "observation_id"
        case value, variance, timestamp
    }
}

struct ObservationClass: Codable {
    var id, userID, consumptionID: Int
    var expectedDivisions: [ExpectedDivision]
    var createdAt: Int
    var equipments: [Equipment]

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case consumptionID = "consumption_id"
        case expectedDivisions = "expected_divisions"
        case createdAt = "created_at"
        case equipments
    }
}

struct ExpectedDivision: Codable {
    var id: Int
    var name: String
}

typealias Observations = [Observation]
