//
//  AlertConfigSheetView.swift
//  SmartEnergyMonitoring
//
//  Created by Daniel Soares Carreira on 01/01/2023.
//

import SwiftUI

struct AlertConfigSheetView: View {
    @Binding var selected: Equipment?
    @Binding var showAlertConfig: Bool
    
    @State private var notifyWhenPassed: Int = 0
    @State private var toggleNotify: Bool = false
    
    @State private var patchLoading = false
    
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
    
    func updateNotificationStatus() -> Void {
        Task {
            do {
                patchLoading = true
                let newNotifyWhenPassed = toggleNotify ? notifyWhenPassed : nil
                let decoded = try JSONEncoder().encode(["notify_when_passed": newNotifyWhenPassed.description])
                try await EquipmentService.patchNotification(userId: (session.user?.data.id)!, accessToken: session.accessToken!, equipmentId: selected!.id, parameters: decoded)
                showAlertConfig = false
                patchLoading = false
            }
            catch APIHelper.APIError.invalidRequestError(let errorMessage) {
                failMessage = errorMessage
                didFail = true
            }
        }
    }
    
    var body: some View {
        VStack {
            List {
                Section {
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
                Button(action: {
                    updateNotificationStatus()
                }, label: {
                    HStack {
                        Text("Save")
                        Spacer()
                        if (patchLoading) {
                            ProgressView()
                        }
                    }
                    
                })
            }
        }
        .onAppear() {
            notifyWhenPassed = selected?.notifyWhenPassed ?? 0
            toggleNotify = notifyWhenPassed != 0
        }
        .alert("Update failed", isPresented: $didFail, actions: {
            Button("Ok") {}
        }, message: {
            Text(failMessage)
        })
    }
}
