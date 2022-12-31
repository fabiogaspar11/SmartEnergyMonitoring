//
//  EquipmentTypes.swift
//  SmartEnergyMonitoring
//
//  Created by Daniel Soares Carreira on 31/12/2022.
//

import Foundation

struct EquipmentTypes: Codable {
    let data: [EquipmentType]
}

struct EquipmentType: Codable, Identifiable {
    let id: Int
    let name: String
    let activity: Activity
}

enum Activity: String, Codable {
    case No = "No"
    case Yes = "Yes"
}
