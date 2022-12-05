//
//  UserService.swift
//  SmartEnergyMonitoring
//
//  Created by Daniel Soares Carreira on 04/12/2022.
//

import Foundation

class UserService {
    static func create(parameters: [String: String]) async throws -> User {
        
        try await APIHelper.request(
            url: "http://smartenergymonitoring.dei.estg.ipleiria.pt/api/users",
            headers: ["Accept":"application/json",
                      "Content-Type":"application/json"],
            parameters: parameters,
            method: "POST",
            type: User.self
        )
    }
}
