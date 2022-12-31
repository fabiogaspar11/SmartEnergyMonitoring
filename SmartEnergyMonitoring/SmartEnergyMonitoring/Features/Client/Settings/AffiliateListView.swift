//
//  AffiliateListView.swift
//  SmartEnergyMonitoring
//
//  Created by Daniel Soares Carreira on 10/12/2022.
//

import SwiftUI

struct AffiliateListView: View {
    @State private var showCreate = false
    @State private var affiliates: Affiliates = []
    
    @State private var didFail = false
    @State private var failMessage = ""
    
    @State private var showDelete = false
    @State private var selected: Affiliate?
    
    @EnvironmentObject var session: SessionManager
    
    var body: some View {
        
        ZStack {
            
            Theme.background.edgesIgnoringSafeArea(.top)
            
            List {
                
                ForEach(affiliates) { affiliate in
                    
                    HStack {
                        Text(affiliate.email)
                        Spacer()
                        Button {
                            selected = affiliate
                            showDelete = true
                        } label: {
                            Symbols.trash
                        }
                    }
                    
                }
            }
            
        }
        .navigationTitle("Affiliates")
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
                    affiliates = try await AffiliateService.fetchMyAffiliates(userId: session.user!.data.id, accessToken: session.accessToken!)
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
                //TODO: remove affiliate
            }
        }, message: {
            Text("Delete \(selected?.email ?? "") from my affiliates")
        })
        
    }
}

struct AffiliateListView_Previews: PreviewProvider {
    static var previews: some View {
        AffiliateListView()
    }
}
