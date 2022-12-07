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
    
    var body: some View {
            
        TabView {
            
            ARView()
                .tabItem {
                    Symbols.ar
                    Text("AR")
                }
                .environmentObject(session)
            
            DashboardView()
                .tabItem {
                    Symbols.home
                    Text("Home")
                }
                .environmentObject(session)
            
            SettingsView()
                .tabItem {
                    Symbols.settings
                    Text("Settings")
                }
                .environmentObject(session)
            
        }
        
    }
    
    struct MainView_Previews: PreviewProvider {
        static var previews: some View {
            MainView()
                .environmentObject(SessionManager())
        }
    }
}
