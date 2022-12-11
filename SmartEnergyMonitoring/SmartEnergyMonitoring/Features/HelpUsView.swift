//
//  HelpUsView.swift
//  SmartEnergyMonitoring
//
//  Created by Daniel Soares Carreira on 11/12/2022.
//

import SwiftUI

struct HelpUsView: View {
    @State var observation: Observation?
    
    @State private var didFail = false
    @State private var failMessage = ""
    
    @State private var divisions: Set<DivisionShort> = []
    
    @EnvironmentObject var session: SessionManager
    
    var body: some View {
        
        List {
            
            ForEach(Array(divisions)) { division in
                
                Section(division.name) {
                    
                    ForEach(observation?.observation.equipments.filter { $0.consumption != "0.00" && $0.division == division.id } ?? []) { equipment in
                        
                        HStack {
                            
                            Text(equipment.name)
                            Spacer()
                            Text("\(equipment.consumption) W")
                            
                        }
                        
                    }
                    
                }
                
            }
            
        }
        .onAppear() {
            
            Task {
                do {
                    observation = try await ObservationService.fetchLast(userId: session.user!.data.id, accessToken: session.accessToken!)
                    
                    observation?.observation.equipments.filter { $0.consumption != "0.00" }.forEach { equipment in
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
        
    }
}

struct HelpUsView_Previews: PreviewProvider {
    static var previews: some View {
        HelpUsView()
    }
}
