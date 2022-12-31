//
//  Users.swift
//  SmartEnergyMonitoring
//
//  Created by Fábio Cordeiro Gaspar on 24/11/2022.
//

import Foundation

struct Users: Codable {
    let data: [UserClass]
}

struct User: Codable {
    let data: UserClass
}

struct UserClass: Codable, Identifiable {
    let id: Int
    let name, email, birthdate: String
    let divisions: [Division]?
    let type, energyPrice: String
    let getStarted, notifications: Int
    let noActivityStart, noActivityEnd: String
    let locked: Int

    enum CodingKeys: String, CodingKey {
        case id, name, email, birthdate, divisions, type
        case energyPrice = "energy_price"
        case getStarted = "get_started"
        case notifications
        case noActivityStart = "no_activity_start"
        case noActivityEnd = "no_activity_end"
        case locked
    }
}
