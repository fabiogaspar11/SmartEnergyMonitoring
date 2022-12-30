//
//  ProfileView.swift
//  SmartEnergyMonitoring
//
//  Created by Daniel Soares Carreira on 10/12/2022.
//

import SwiftUI

struct ProfileView: View {
    @State private var notifications: Bool = false
    @State private var birthDate: Date = Date()
    @State private var wakeTime: Date = Date()
    @State private var bedTime: Date = Date()
    @State private var energyPrice: Float = 0.15
    @State private var name: String = ""
    
    @EnvironmentObject var session: SessionManager
    
    var body: some View {
        
        ZStack {
            
            Theme.background.edgesIgnoringSafeArea(.top)
            
            List {
                
                Section {
                    
                    HStack {
                        Text("Name")
                        Spacer()
                        Text(name)
                            .foregroundStyle(.secondary)
                    }
                    HStack {
                        Text("E-mail")
                        Spacer()
                        Text((session.user?.data.email)!)
                            .foregroundStyle(.secondary)
                    }
                    DatePicker(
                        "Birth Date",
                        selection: $birthDate,
                        in: ...Date.now,
                        displayedComponents: .date
                    )
                }
                
                Section("Energy") {
                    VStack {
                        HStack {
                            Text("Price")
                            Spacer()
                            Text("\(String(format: "%.3f", energyPrice)) € / kWh")
                                .foregroundStyle(.secondary)
                        }
                        Slider(value: $energyPrice, in: 0...0.5)
                            .tint(Theme.primary)
                            .padding()
                    }
                }
                
                Section("Routine") {
                    
                    DatePicker(
                        "Wake Up Time",
                        selection: $wakeTime,
                        in: ...Date.now,
                        displayedComponents: .hourAndMinute
                    )
                    DatePicker(
                        "Bed Time",
                        selection: $bedTime,
                        in: ...Date.now,
                        displayedComponents: .hourAndMinute
                    )
                    
                }
            }
            
        }
        .navigationTitle("Profile")
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
