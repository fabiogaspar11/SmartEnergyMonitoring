//
//  ContentView.swift
//  SmartEnergyMonitoring
//
//  Created by Fábio Cordeiro Gaspar
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var session = SessionManager()
    
    var body: some View {
        switch session.currentState {
        case .loggedIn:
            MainView()
                .environmentObject(session)
                .transition(.opacity)
        case .register:
            RegisterView()
                .environmentObject(session)
                .transition(.opacity)
        default:
            LoginView()
                .environmentObject(session)
                .transition(.opacity)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
