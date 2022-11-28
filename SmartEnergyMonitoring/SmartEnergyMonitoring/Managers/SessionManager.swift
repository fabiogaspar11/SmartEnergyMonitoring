//
//  SessionManager.swift
//  SmartEnergyMonitoring
//
//  Created by Fábio Cordeiro Gaspar on 24/11/2022.
//

import SwiftUI

final class SessionManager: ObservableObject {
    
    enum CurrentState {
        case loggedIn
        case loggedOut
    }
    
    @Published private(set) var currentState: CurrentState?
    @Published private(set) var auth: Auth?
    
    func signIn(_ credentials: [String: String]) {
        auth = AuthHelper.login(credentials)
        currentState = .loggedIn
    }
    
    func signOut() {
        currentState = .loggedOut
    }
    
}
