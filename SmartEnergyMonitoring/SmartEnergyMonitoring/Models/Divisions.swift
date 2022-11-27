//
//  Divisions.swift
//  SmartEnergyMonitoring
//
//  Created by Fábio Cordeiro Gaspar on 24/11/2022.
//

import Foundation

struct Divisions: Codable {
    let data: [Division]
}

struct Division: Codable {
    let id: Int
    let name: String
}
