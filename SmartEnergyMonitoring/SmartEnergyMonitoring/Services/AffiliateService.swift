//
//  AffiliateService.swift
//  SmartEnergyMonitoring
//
//  Created by Daniel Soares Carreira on 10/12/2022.
//

import Foundation

class AffiliateService {
    
    static func fetch(userId: Int, accessToken: String) async throws -> Affiliates {
        
        return try await APIHelper.request(
            url: "http://smartenergymonitoring.dei.estg.ipleiria.pt/api/users/\(userId)/affiliates",
            headers: ["Accept":"application/json",
                      "Content-Type":"application/json",
                      "Authorization":"Bearer \(accessToken)"],
            method: "GET",
            type: Affiliates.self
        )
        
    }
    
    static func fetchMyAffiliates(userId: Int, accessToken: String) async throws -> Affiliates {
        
        return try await APIHelper.request(
            url: "http://smartenergymonitoring.dei.estg.ipleiria.pt/api/users/\(userId)/affiliates/my",
            headers: ["Accept":"application/json",
                      "Content-Type":"application/json",
                      "Authorization":"Bearer \(accessToken)"],
            method: "GET",
            type: Affiliates.self
        )
        
    }
    
}
