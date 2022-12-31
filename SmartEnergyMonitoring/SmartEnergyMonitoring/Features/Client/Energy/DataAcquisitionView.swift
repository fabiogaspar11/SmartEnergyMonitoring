//
//  DataAcquisitionView.swift
//  SmartEnergyMonitoring
//
//  Created by Daniel Soares Carreira on 30/12/2022.
//

import SwiftUI

struct DataAcquisitionView: View {
    @State private var equipment: Equipment
    @State private var time: Int = 1
    
    @State private var didFail = false
    @State private var failMessage = ""
    
    @State private var state: StateView = .First
    
    @EnvironmentObject var session: SessionManager
    @EnvironmentObject var mqtt: MQTTManager
    
    init(equipment: Equipment) {
        self.equipment = equipment
    }
    
    enum StateView: Int, CaseIterable, Comparable {
        static func < (lhs: DataAcquisitionView.StateView, rhs: DataAcquisitionView.StateView) -> Bool {
            return lhs.rawValue < rhs.rawValue
        }
        
        case First = 1
        case Second = 2
        case Third = 3
        case Fourth = 4
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                Theme.background.edgesIgnoringSafeArea(.top)
                
                VStack {
                    List {
                        HStack {
                            Symbols.oneFill
                                .foregroundColor(.accentColor)
                            Spacer()
                            if (state < .Second) {
                                Symbols.two
                                    .foregroundColor(.accentColor)
                            }
                            else {
                                Symbols.twoFill
                                    .foregroundColor(.accentColor)
                            }
                            Spacer()
                            if (state < .Third) {
                                Symbols.three
                                    .foregroundColor(.accentColor)
                            }
                            else {
                                Symbols.threeFill
                                    .foregroundColor(.accentColor)
                            }
                            Spacer()
                            if (state < .Fourth) {
                                Symbols.four
                                    .foregroundColor(.accentColor)
                            }
                            else {
                                Symbols.fourFill
                                    .foregroundColor(.accentColor)
                            }
                        }
                        if (state == .First) {
                            Section("Info") {
                                Text("This type of tool should be used to improve the accuracy of the system. The user must use this tool by following all the steps in the order they are presented, otherwise the monitoring system's conclusions will yield false results.")
                                    .foregroundStyle(.secondary)
                            }
                            
                            Button("Let's start →") {
                                state = .Second
                            }
                        }
                        else if (state == .Second) {
                            Section("Info") {
                                Text("Please select a period of analysis (recommended between 1..5 minutes). Afterwards, be sure that the \(equipment.name) is turned OFF.")
                                    .foregroundStyle(.secondary)
                            }
                            Stepper(value: $time, in: 1...60) {
                                HStack {
                                    Text("Time: ")
                                    Text("\(time) minute(s)")
                                        .foregroundStyle(.secondary)
                                }
                            }
                            Button("Next →") {
                                state = .Third
                            }
                        }
                        else if (state == .Third) {
                            Section("Info") {
                                Text("Now, turn ON the \(equipment.name) and proceed.")
                                    .foregroundStyle(.secondary)
                            }
                            
                            Button("Begin analysis →") {
                                state = .Fourth
                            }
                        }
                        else if (state == .Fourth) {
                            Section("Info") {
                                HStack {
                                    Text("Time remaining")
                                    Spacer()
                                    Text("59 s")
                                        .foregroundStyle(.secondary)
                                }
                                HStack {
                                    Text("Consumption")
                                    Spacer()
                                    Text("300 W")
                                        .foregroundStyle(.secondary)
                                }
                            }
                            
                            Button(action: {
                                let timeRemaining = 2
                                if (timeRemaining > 0) {
                                    
                                }
                            }) {
                                let timeRemaining = 2
                                if (timeRemaining > 0) {
                                    Text("Stop!")
                                }
                                else {
                                    Text("Done!")
                                }
                            }
                        }
                    }
                }
            }
        }.alert("Data fetch failed", isPresented: $didFail, actions: {
            Button("Ok") {}
        }, message: {
            Text(failMessage)
        })
        .navigationTitle("Data Acquisition")
    }
}
