//
//  AuthHelper.swift
//  SmartEnergyMonitoring
//
//  Created by Daniel Soares Carreira on 27/11/2022.
//

import SwiftUI

class AuthHelper : ObservableObject {
    
    static func login(_ credentials: [String: String]) -> Auth {
        
        let auth = APIHelper.request(
            url: "http://smartenergymonitoring.dei.estg.ipleiria.pt/api/login",
            parameters: credentials,
            method: "POST",
            type: Auth.self
        )
        
        return auth
        
    }
}
