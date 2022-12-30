//
//  AlertConfigView.swift
//  SmartEnergyMonitoring
//
//  Created by Daniel Soares Carreira on 30/12/2022.
//

import SwiftUI

struct AlertConfigView: View {
    @State private var equipments: Equipments?
    @State private var equipmentsLoading = true
    
    @State private var selected: Equipment?
    @State private var notifyWhenPassed: Int = 0
    @State private var toggleNotify: Bool = false
    @State private var showAlertConfig = false
    
    @State private var didFail = false
    @State private var failMessage = ""
    
    @EnvironmentObject var session: SessionManager
    
    var intProxy: Binding<Double>{
        Binding<Double>(get: {
            return Double(notifyWhenPassed)
        }, set: {
            notifyWhenPassed = Int($0)
        })
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                Theme.background.edgesIgnoringSafeArea(.top)
                
                VStack {
                    if (equipmentsLoading) {
                        ProgressView()
                    }
                    else {
                        List {
                            Section("Equipments") {
                                ForEach(equipments?.data ?? []) { equipment in
                                    Button(action: {
                                        selected = equipment
                                        showAlertConfig = true
                                    }, label: {
                                        HStack {
                                            VStack(alignment: .leading) {
                                                Text(equipment.name)
                                                    .foregroundColor(Theme.text)
                                                Text("Division: \(equipment.divisionName)")
                                                    .foregroundColor(.gray)
                                            }
                                            Spacer()
                                            HStack {
                                                Text("\(equipment.notifyWhenPassed == nil ? "" : String(equipment.notifyWhenPassed!) + " minute(s)")")
                                                    .foregroundColor(.gray)
                                                Symbols.arrow
                                                    .foregroundColor(.gray)
                                            }
                                        }
                                    })
                                }
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Configuration")
        .onAppear() {
            Task {
                do {
                    equipmentsLoading = true
                    equipments = try await EquipmentService.fetch(userId: (session.user?.data.id)!, accessToken: session.accessToken!)
                    equipmentsLoading = false
                }
                catch APIHelper.APIError.invalidRequestError(let errorMessage) {
                    failMessage = errorMessage
                    didFail = true
                }
                catch APIHelper.APIError.decodingError {
                    failMessage = "Decoding Error"
                    didFail = true
                }
            }
        }
        .alert("Data fetch failed", isPresented: $didFail, actions: {
            Button("Ok") {}
        }, message: {
            Text(failMessage)
        })
        .sheet(isPresented: $showAlertConfig, content: {
            VStack {
                List {
                    Section("Details") {
                        HStack {
                            Text("Name")
                            Spacer()
                            Text(selected?.name ?? "")
                                .foregroundStyle(.secondary)
                        }
                        HStack {
                            Text("Division")
                            Spacer()
                            Text(selected?.divisionName ?? "")
                                .foregroundStyle(.secondary)
                        }
                    }
                    
                    Section("Config") {
                        Toggle("Notifications", isOn: $toggleNotify)
                            .tint(Theme.primary)
                        if (toggleNotify) {
                            VStack {
                                HStack {
                                    Text("Time")
                                    Spacer()
                                    Text("\(notifyWhenPassed) minute(s)")
                                        .foregroundStyle(.secondary)
                                }
                                Slider(value: intProxy, in: 0.0...120.0, step: 1.0)
                                    .tint(Theme.primary)
                                    .padding()
                            }
                        }
                    }
                    
                    Button("Save") {
                        
                    }
                }
                .onAppear() {
                    notifyWhenPassed = selected?.notifyWhenPassed ?? 0
                    toggleNotify = notifyWhenPassed != 0
                }
            }
        })
    }
}
