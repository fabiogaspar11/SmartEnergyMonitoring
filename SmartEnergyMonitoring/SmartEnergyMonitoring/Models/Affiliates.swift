//
//  Affiliates.swift
//  SmartEnergyMonitoring
//
//  Created by Fábio Cordeiro Gaspar on 24/11/2022.
//

import Foundation

struct Affiliate: Codable {
    let id: Int
    let name, email, energyPrice: String

    enum CodingKeys: String, CodingKey {
        case id, name, email
        case energyPrice = "energy_price"
    }
}

typealias Affiliates = [Affiliate]
