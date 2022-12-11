//
//  DivisionService.swift
//  SmartEnergyMonitoring
//
//  Created by Daniel Soares Carreira on 09/12/2022.
//

import Foundation

class DivisionService {
    
    static func fetch(userId: Int, accessToken: String) async throws -> Divisions {
        
        return try await APIHelper.request(
            url: "http://smartenergymonitoring.dei.estg.ipleiria.pt/api/users/\(userId)/divisions",
            headers: ["Accept":"application/json",
                      "Content-Type":"application/json",
                      "Authorization":"Bearer \(accessToken)"],
            method: "GET",
            type: Divisions.self
        )
        
    }
    
}
