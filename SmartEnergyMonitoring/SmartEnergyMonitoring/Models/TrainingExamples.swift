//
//  TrainingExamples.swift
//  SmartEnergyMonitoring
//
//  Created by Daniel Soares Carreira on 02/01/2023.
//

import Foundation

struct TrainingExamples: Codable {
    var start, end: Int
    var equipments: [String: Double]
}
