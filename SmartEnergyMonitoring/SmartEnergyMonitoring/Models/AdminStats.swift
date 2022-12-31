//
//  AdminStats.swift
//  SmartEnergyMonitoring
//
//  Created by Daniel Soares Carreira on 31/12/2022.
//

import Foundation

struct AdminStatsUsers: Codable {
    let clients, producers, admins: Int
}

struct AdminStats: Codable {
    let observations, consumptions, alerts: Int
}
