//
//  EnergyView.swift
//  SmartEnergyMonitoring
//
//  Created by Daniel Soares Carreira on 10/12/2022.
//

import SwiftUI

struct EnergyView: View {
    @State private var equipmentsLoading = true
    @State private var equipments: Equipments?
    @State private var observationLoading = true
    @State private var latestObservation: Observation?
    
    @State private var todoList: [Equipment] = []
    @State private var doneList: [Equipment] = []
    
    @State private var didFail = false
    @State private var failMessage = ""
    
    @EnvironmentObject var session: SessionManager
    
    struct NameValue: Identifiable {
        let id = UUID()
        var name: String
        var value: String
        var items: [NameValue] = []
    }
    
    var body: some View {
        
        NavigationStack {
            
            ZStack {
                
                Theme.background.edgesIgnoringSafeArea(.top)
                
                List {
                    Section("To Do") {
                        NavigationLink(destination: VerifyPredictionView(observation: $latestObservation, equipments: $equipments)) {
                            HStack {
                                Symbols.circle
                                    .foregroundStyle(Theme.primary)
                                Text("Verify Prediction")
                                    .foregroundColor(Theme.text)
                                Spacer()
                                if (observationLoading) {
                                    ProgressView()
                                }
                            }
                        }
                        ForEach(todoList) { equipment in
                            NavigationLink(destination: DataAcquisitionView(equipment: equipment)) {
                                HStack {
                                    Symbols.circle
                                        .foregroundStyle(Theme.primary)
                                    Text(equipment.name)
                                        .foregroundColor(Theme.text)
                                    Spacer()
                                    Text("\(equipment.examples) reads")
                                        .foregroundStyle(.gray)
                                }
                            }
                        }
                    }
                    
                    Section("Done") {
                        ForEach(doneList) { equipment in
                            NavigationLink(destination: DataAcquisitionView(equipment: equipment)) {
                                HStack {
                                    Symbols.checkmark
                                        .foregroundStyle(Theme.primary)
                                    Text(equipment.name)
                                        .foregroundColor(Theme.text)
                                    Spacer()
                                    Text("\(equipment.examples) reads")
                                        .foregroundStyle(.gray)
                                }
                            }
                        }
                    }
                    
                }
            }
            .navigationTitle("Energy")
            .onAppear() {
                Task {
                    do {
                        observationLoading = true
                        latestObservation = try await ObservationService.fetchLast(userId: (session.user?.data.id)!, accessToken: session.accessToken!)
                        observationLoading = false
                        
                        equipmentsLoading = true
                        equipments = try await EquipmentService.fetch(userId: (session.user?.data.id)!, accessToken: session.accessToken!)
                        equipmentsLoading = false
                        
                        todoList = (equipments?.data.filter{ $0.examples == 0 })!
                        doneList = (equipments?.data.filter{ $0.examples > 0 })!
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
        }
    }
}
