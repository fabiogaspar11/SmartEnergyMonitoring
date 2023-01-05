//
//  EquipmentView.swift
//  SmartEnergyMonitoring
//
//  Created by Daniel Soares Carreira on 11/12/2022.
//

import SwiftUI

struct EquipmentView: View {
    @State var equipment: Equipment
    
    @State private var showDelete = false
    @State private var showEdit = false
    
    @State private var didFail = false
    @State private var failMessage = ""
    
    @EnvironmentObject var session: SessionManager
    @Environment(\.dismiss) var dismiss
    
    func delete() {
        Task {
            do {
                try await EquipmentService.delete(userId: session.user!.data.id, accessToken: session.accessToken!, equipmentId: equipment.id)
                dismiss()
            }
            catch APIHelper.APIError.invalidRequestError(let errorMessage) {
                failMessage = errorMessage
                didFail = true
            }
        }
    }
    
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
                HStack {
                    Text("Type")
                    Spacer()
                    Text(equipment.typeName)
                        .foregroundStyle(.secondary)
                }
                HStack {
                    Text("Division")
                    Spacer()
                    Text(equipment.divisionName)
                        .foregroundStyle(.secondary)
                }
                HStack {
                    Text("Consumption")
                    Spacer()
                    Text("\(equipment.consumption) W")
                        .foregroundStyle(.secondary)
                }
                HStack {
                    Text("Manual Activation")
                    Spacer()
                    Text(equipment.activity)
                        .foregroundStyle(.secondary)
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
        .sheet(isPresented: $showEdit, content: {
            EquipmentEditView(equipment: equipment)
        })
        .alert("Are you sure?", isPresented: $showDelete, actions: {
            Button("Delete", role: .destructive) {
                delete()
            }
        }, message: {
            Text("Delete \(equipment.name) from your devices")
        })
        
    }
}
