//
//  UserService.swift
//  SmartEnergyMonitoring
//
//  Created by Daniel Soares Carreira on 04/12/2022.
//

import Foundation

class UserService {
    
    static func create(parameters: [String: String]) async throws -> User {
        
        return try await APIHelper.request(
            url: "http://smartenergymonitoring.dei.estg.ipleiria.pt/api/users",
            headers: ["Accept":"application/json",
                      "Content-Type":"application/json"],
            parameters: parameters,
            method: "POST",
            type: User.self
        )
        
    }
    
    static func fetch(accessToken: String) async throws -> User {
        
        let authUser = try await APIHelper.request(
            url: "http://smartenergymonitoring.dei.estg.ipleiria.pt/api/user",
            headers: ["Accept":"application/json",
                      "Content-Type":"application/json",
                      "Authorization":"Bearer \(accessToken)"],
            method: "GET",
            type: UserClass.self
        )
        
        return User(data: authUser)
        
    }
    
}
