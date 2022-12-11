//
//  SettingsView.swift
//  SmartEnergyMonitoring
//
//  Created by Fábio Cordeiro Gaspar on 24/11/2022.
//

import SwiftUI

struct SettingsView: View {
    @State private var notifications: Bool = false
    @State private var birthDate: Date = Date()
    @State private var wakeTime: Date = Date()
    @State private var bedTime: Date = Date()
    @State private var energyPrice: Float = 0.15
    @State private var name: String = ""
    
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
                        
                        VStack {
                            HStack {
                                Text("Energy Price")
                                Spacer()
                                Text("\(String(format: "%.3f", energyPrice)) € / kWh")
                                    .foregroundStyle(.secondary)
                            }
                            Slider(value: $energyPrice, in: 0...0.5)
                                .tint(Theme.primary)
                                .padding()
                        }
                        
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
                
                name = user!.name
                notifications = user!.notifications == 1
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                birthDate = dateFormatter.date(from: user!.birthdate)!
                
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                bedTime = dateFormatter.date(from: user!.noActivityStart)!
                wakeTime = dateFormatter.date(from: user!.noActivityEnd)!
                
                energyPrice = Float(user!.energyPrice)!
                
            }
            
        }
        
    }
    
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
