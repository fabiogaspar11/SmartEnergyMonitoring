//
//  UserStats.swift
//  SmartEnergyMonitoring
//
//  Created by Fábio Cordeiro Gaspar on 24/11/2022.
//

import Foundation

struct UserStat: Codable {
    let timestamp, value: String
}

typealias UserStats = [UserStat]
