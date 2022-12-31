//
//  VerifyPredictionView.swift
//  SmartEnergyMonitoring
//
//  Created by Daniel Soares Carreira on 30/12/2022.
//

import SwiftUI

struct VerifyPredictionView: View {
    @Binding var observation: Observation?
    @Binding var equipments: Equipments?
    
    @State private var divisions: [DivisionShort] = []
    
    @State private var didFail = false
    @State private var failMessage = ""
    
    @EnvironmentObject var session: SessionManager
    
    func submitManualLabel() -> Void {
        //TODO: post request
    }
    
    init(observation: Binding<Observation?>, equipments: Binding<Equipments?>) {
        self._observation = observation
        self._equipments = equipments
        var divSet: Set<DivisionShort> = []
        self.equipments?.data.forEach { equipment in
            let division = DivisionShort(id: equipment.division, name: equipment.divisionName)
            divSet.insert(division)
        }
        divisions = Array(divSet)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                Theme.background.edgesIgnoringSafeArea(.top)
                
                VStack {
                    List {
                        Section {
                            HStack {
                                Text("Date")
                                Spacer()
                                Text(unixTimestampToFormatedString(observation!.consumption.timestamp))
                                    .foregroundStyle(.secondary)
                            }
                        }
                        
                        Section("Equipments") {
                            ForEach(observation?.observation.equipments ?? []) { equipment in
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(equipment.name)
                                        Text("Division: \(equipment.divisionName)")
                                            .foregroundStyle(.secondary)
                                    }
                                    Spacer()
                                    Text("\(equipment.consumption) W")
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                        
                        Section {
                            Button("Record →") {
                                
                            }
                        }
                        
                    }
                }
                
            }
        }
        .alert("Data fetch failed", isPresented: $didFail, actions: {
            Button("Ok") {}
        }, message: {
            Text(failMessage)
        })
        .navigationTitle("Verify Prediction")
    }
}
