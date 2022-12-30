//
//  AlertsView.swift
//  SmartEnergyMonitoring
//
//  Created by Daniel Soares Carreira on 30/12/2022.
//

import SwiftUI

struct AlertListView: View {
    @State private var alerts: Alerts?
    @State private var alertLoading = true
    
    @State private var equipments: Equipments?
    @State private var equipmentsLoading = true
    
    @State private var showConfig = false
    
    @State private var didFail = false
    @State private var failMessage = ""
    
    @EnvironmentObject var session: SessionManager
    
    var body: some View {
        NavigationStack {
            
            ZStack {
                
                Theme.background.edgesIgnoringSafeArea(.top)
                
                if (alertLoading) {
                    ProgressView()
                }
                else {
                    List {
                        ForEach(alerts?.data ?? []) { alert in
                            Section(content: {
                                Text(alert.alert)
                            }, footer: {
                                HStack {
                                    Spacer()
                                    Text(stringDateToPrettyStringDate(alert.timestamp))
                                }
                            })
                        }
                    }
                }
            }
        }
        .onAppear() {
            Task {
                do {
                    alertLoading = true
                    alerts = try await AlertService.fetchAll(userId: (session.user?.data.id)!, accessToken: session.accessToken!)
                    alertLoading = false
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
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                NavigationLink(destination: AlertConfigView(), label: {
                    Symbols.settings
                    Text("Config")
                })
            }
            
        }
        .alert("Data fetch failed", isPresented: $didFail, actions: {
            Button("Ok") {}
        }, message: {
            Text(failMessage)
        })
        .navigationTitle("Alerts")
        .sheet(isPresented: $showConfig, content: {
            AlertConfigView()
        })
    }
}
