//
//  EquipmentView.swift
//  SmartEnergyMonitoring
//
//  Created by Daniel Soares Carreira on 11/12/2022.
//

import SwiftUI

struct EquipmentView: View {
    @State var equipment: Equipment
    @State var divisions: Divisions?
    
    @State var selectedDivision = 0
    @State var selectedActivity = "Yes"
    
    @State private var didFail = false
    @State private var failMessage = ""
    
    @State private var showDelete = false
    @State private var showEdit = false
    
    @EnvironmentObject var session: SessionManager
    
    var body: some View {
        
        ZStack {
            
            Theme.background.edgesIgnoringSafeArea(.top)
            
            List {
                
                HStack {
                    Text("Name")
                    Spacer()
                    Text(equipment.name)
                        .foregroundStyle(.secondary)
                }
                Picker("Division", selection: $selectedDivision) {
                    ForEach(divisions?.data ?? []) { division in
                        Text(division.name).tag(division.id)
                    }
                }
                HStack {
                    Text("Consumption")
                    Spacer()
                    Text("\(equipment.consumption) W")
                        .foregroundStyle(.secondary)
                }
                Picker("Manual Activation", selection: $selectedActivity) {
                    Text("Yes").tag("Yes")
                    Text("No").tag("No")
                }
                
            }
            
        }
        .navigationTitle(equipment.name)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Menu {
                    Button {
                        showEdit = true
                    }
                    label: {
                        Symbols.edit
                        Text("Edit")
                    }
                    Button {
                        showDelete = true
                    }
                    label: {
                        Symbols.delete
                        Text("Delete")
                    }
                } label: {
                    HStack {
                        Symbols.options
                        Text("Actions")
                    }
                }
            }
        }
        .onAppear() {
            
            Task {
                do {
                    selectedDivision = equipment.division
                    selectedActivity = equipment.activity
                    divisions = try await DivisionService.fetch(userId: session.user!.data.id, accessToken: session.accessToken!)
                    
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
        })
        
    }
}
