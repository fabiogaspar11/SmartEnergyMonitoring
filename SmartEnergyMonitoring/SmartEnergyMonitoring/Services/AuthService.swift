//
//  AuthService.swift
//  SmartEnergyMonitoring
//
//  Created by Daniel Soares Carreira on 04/12/2022.
//

import Foundation

class AuthService {
    static func login(credentials: [String: String]) async throws -> Auth {
        
        return try await APIHelper.request(
            url: "http://smartenergymonitoring.dei.estg.ipleiria.pt/api/login",
            headers: ["Accept":"application/json",
                      "Content-Type":"application/json"],
            parameters: credentials,
            method: "POST",
            type: Auth.self
        )
        
    }
}
