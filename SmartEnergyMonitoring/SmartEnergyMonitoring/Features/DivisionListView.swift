//
//  DivisionListView.swift
//  SmartEnergyMonitoring
//
//  Created by Daniel Soares Carreira on 10/12/2022.
//

import SwiftUI

struct DivisionListView: View {
    @State private var showCreate = false
    @State private var divisions: Divisions?
    
    @State private var didFail = false
    @State private var failMessage = ""
    
    @State private var showDelete = false
    @State private var selected: Division?
    
    @EnvironmentObject var session: SessionManager
    
    var body: some View {
        
        ZStack {
            
            Theme.background.edgesIgnoringSafeArea(.top)
            
            List {
                
                ForEach(divisions?.data ?? []) { division in
                    
                    HStack {
                        Text(division.name)
                        Spacer()
                        Button {
                            selected = division
                            showDelete = true
                        } label: {
                            Symbols.trash
                        }
                    }
                    
                }
                
            }
            
        }
        .navigationTitle("Divisions")
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
                //TODO: remove division
            }
        }, message: {
            Text("Delete \(selected?.name ?? "") from my divisions")
        })
        
    }
}

struct DivisionListView_Previews: PreviewProvider {
    static var previews: some View {
        DivisionListView()
    }
}
