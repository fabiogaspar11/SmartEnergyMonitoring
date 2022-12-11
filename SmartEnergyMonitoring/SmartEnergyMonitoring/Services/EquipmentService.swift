//
//  EquipmentService.swift
//  SmartEnergyMonitoring
//
//  Created by Daniel Soares Carreira on 11/12/2022.
//

import Foundation

class EquipmentService {
    
    static func fetch(userId: Int, accessToken: String) async throws -> Equipments {
        
        return try await APIHelper.request(
            url: "http://smartenergymonitoring.dei.estg.ipleiria.pt/api/users/\(userId)/equipments",
            headers: ["Accept":"application/json",
                      "Content-Type":"application/json",
                      "Authorization":"Bearer \(accessToken)"],
            method: "GET",
            type: Equipments.self
        )
        
    }
    
}