//
//  HelpUsView.swift
//  SmartEnergyMonitoring
//
//  Created by Daniel Soares Carreira on 11/12/2022.
//

import SwiftUI

struct ObservationView: View {
    @Binding var observation: Observation?
    @Binding var divisions: Set<DivisionShort>
    
    @State private var title: String = ""
    
    @EnvironmentObject var session: SessionManager
    
    var body: some View {
        
        VStack {
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top)
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
            .background(Theme.background)
        }
        .background(Theme.background)
        .onAppear() {
            let formatedDate = unixTimestampToFormatedString(observation!.consumption.timestamp)
            title = "Observation of " + formatedDate
        }
    }
}
