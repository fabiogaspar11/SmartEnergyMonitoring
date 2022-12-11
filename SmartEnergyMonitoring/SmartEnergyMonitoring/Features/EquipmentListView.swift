//
//  EquipmentListView.swift
//  SmartEnergyMonitoring
//
//  Created by Daniel Soares Carreira on 10/12/2022.
//

import SwiftUI

struct EquipmentListView: View {
    @State private var showCreate = false
    @State private var equipments: Equipments?
    @State private var divisions: Set<DivisionShort> = []
    
    @State private var didFail = false
    @State private var failMessage = ""
    
    @State private var showDelete = false
    @State private var selected: Equipment?
    
    @EnvironmentObject var session: SessionManager
    
    var body: some View {
        
        ZStack {
            
            Theme.background.edgesIgnoringSafeArea(.top)
            
            List {
                
                ForEach(Array(divisions)) { division in
                    
                    Section(division.name) {
                        
                        ForEach(equipments?.data.filter { $0.division == division.id } ?? []) { equipment in
                            
                            HStack {
                                Text(equipment.name)
                                Spacer()
                                Button {
                                    selected = equipment
                                    showDelete = true
                                } label: {
                                    Symbols.trash
                                }
                            }
                            
                        }
                        
                    }
                    
                }
                
            }
            
        }
        .navigationTitle("Equipments")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showCreate = true
                }
                label: {
                    Symbols.plus
                    Text("New")
                }
            }
        }
        .onAppear() {
            
            Task {
                do {
                    equipments = try await EquipmentService.fetch(userId: session.user!.data.id, accessToken: session.accessToken!)
                    
                    equipments?.data.forEach { equipment in
                        let division = DivisionShort(id: equipment.division, name: equipment.divisionName)
                        divisions.insert(division)
                    }
                    
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
        .alert("Are you sure?", isPresented: $showDelete, actions: {
            Button("Delete", role: .destructive) {
                //TODO: remove equipment
            }
        }, message: {
            Text("Delete \(selected?.name ?? "") from my equipments")
        })
        
    }
}

struct EquipmentListView_Previews: PreviewProvider {
    static var previews: some View {
        EquipmentListView()
    }
}
