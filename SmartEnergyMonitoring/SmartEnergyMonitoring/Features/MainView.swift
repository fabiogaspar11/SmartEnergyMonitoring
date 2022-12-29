//
//  MainView.swift
//  SmartEnergyMonitoring
//
//  Created by Fábio Cordeiro Gaspar on 05/10/2022.
//

import SwiftUI

struct MainView: View {
    let screenHeight = UIScreen.main.bounds.size.height
    let screenWidth = UIScreen.main.bounds.size.width
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    @EnvironmentObject var session: SessionManager
    @StateObject var mqtt = MQTTManager.shared()
    
    var body: some View {
            
        TabView {
            
            DashboardView()
                .tabItem {
                    Symbols.home
                    Text("Home")
                }
                .environmentObject(session)
                .environmentObject(mqtt)
            
            
            EnergyView()
                .tabItem {
                    Symbols.bolt
                    Text("Energy")
                }
                .environmentObject(session)
                .environmentObject(mqtt)
            
            
            ARView()
                .tabItem {
                    Symbols.ar
                    Text("AR")
                }
                .environmentObject(session)
            
            
            SettingsView()
                .tabItem {
                    Symbols.settings
                    Text("Settings")
                }
                .environmentObject(session)
            
        }
        .onAppear() {
            
            mqtt.initializeMQTT()
            mqtt.connect()
        }
        
    }
}
