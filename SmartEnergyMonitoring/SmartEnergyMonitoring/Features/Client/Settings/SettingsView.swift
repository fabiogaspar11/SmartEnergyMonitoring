//
//  SettingsView.swift
//  SmartEnergyMonitoring
//
//  Created by Fábio Cordeiro Gaspar on 24/11/2022.
//

import SwiftUI

struct SettingsView: View {
    @State private var notifications: Bool = false
    
    @EnvironmentObject var session: SessionManager
    
    var body: some View {
        
        NavigationStack {
            
            ZStack {
                
                Theme.background.edgesIgnoringSafeArea(.top)
                
                List {
                    
                    NavigationLink("Profile", destination: ProfileView())
                    
                    NavigationLink("Affiliates", destination: AffiliateListView())
                    
                    Toggle("Notifications", isOn: $notifications)
                        .tint(Theme.primary)
                    
                    Section("Household") {
                        
                        NavigationLink("Divisions", destination: DivisionListView())
                        
                        NavigationLink("Equipments", destination: EquipmentListView())
                        
                    }
                    
                    Section("Security") {
                        
                        Button("Change Password") {
                            //TODO: Open sheet to change password
                        }
                        
                    }
                    
                }
                
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        // TODO: action
                        session.signOut()
                    }
                    label: {
                        Symbols.logout
                        Text("Logout")
                    }
                }
            }
            .onAppear() {
                let user = session.user?.data
                notifications = user!.notifications == 1
            }
            
        }
        
    }
    
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
