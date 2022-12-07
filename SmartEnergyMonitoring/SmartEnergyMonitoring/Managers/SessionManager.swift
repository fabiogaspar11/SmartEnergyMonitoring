//
//  SessionManager.swift
//  SmartEnergyMonitoring
//
//  Created by Fábio Cordeiro Gaspar on 24/11/2022.
//

import SwiftUI

@MainActor
final class SessionManager: ObservableObject {
    
    enum CurrentState {
        case loggedIn
        case loggedOut
        case register
    }
    
    @Published private(set) var currentState: CurrentState?
    @Published private(set) var auth: Auth?
    
    func signIn(_ credentials: [String: String]) async throws {
        
        auth = try await AuthService.login(credentials: credentials)
        currentState = .loggedIn
    }
    
    func signOut() {
        currentState = .loggedOut
    }
    
    func register() {
        currentState = .register
    }
    
}
