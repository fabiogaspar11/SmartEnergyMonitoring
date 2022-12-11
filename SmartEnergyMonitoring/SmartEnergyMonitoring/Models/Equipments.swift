//
//  Equipments.swift
//  SmartEnergyMonitoring
//
//  Created by Fábio Cordeiro Gaspar on 24/11/2022.
//

import Foundation

struct Equipments: Codable {
    let data: [Equipment]
}

struct Equipment: Codable, Identifiable {
    let id, userID: Int
    let name: String
    let division: Int
    let divisionName: String
    let type: Int
    let typeName, consumption, activity: String
    let equipmentTypeID, examples: Int
    let initStatusOn: String?
    let notifyWhenPassed: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case name, division
        case divisionName = "division_name"
        case type
        case typeName = "type_name"
        case consumption, activity
        case equipmentTypeID = "equipment_type_id"
        case examples
        case initStatusOn = "init_status_on"
        case notifyWhenPassed = "notify_when_passed"
    }
}

struct DivisionShort: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct EquipmentShort: Codable {
    let id: Int
    let name, consumption, type, activity, division: String
}
