//
//  DashboardView.swift
//  SmartEnergyMonitoring
//
//  Created by Fábio Cordeiro Gaspar on 24/11/2022.
//

import SwiftUI

struct DashboardView: View {
    
    @State private var divisions: Divisions?
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 10), count: 2)
    
    @State private var didFail = false
    @State private var failMessage = ""
    
    @State private var selectedView: Int = 0
    @State private var affiliates: Affiliates = []
    
    @State private var showSwap = false
    
    @EnvironmentObject var session: SessionManager
    
    var body: some View {
        
        NavigationStack {
            
            ZStack {
                
                Theme.background.edgesIgnoringSafeArea(.top)
                
                List {
                    
                    Section(content: {
                        
                        LazyVGrid(columns: columns, spacing: 16) {
                                
                            ForEach(divisions?.data ?? []) { division in
                                Button {
                                    
                                } label: {
                                    ZStack {
                                        
                                        Color.white
                                        
                                        VStack() {
                                            
                                            Text(division.name)
                                                .font(.system(size: 22, weight: .bold))
                                                .foregroundColor(Theme.primary)
                                                .padding()
                                            
                                            Text("- W")
                                                .font(.system(size: 19, weight: .bold))
                                                .foregroundColor(Theme.text)
                                                .padding(.bottom)
                                            
                                        }
                                        
                                        HStack {
                                            Spacer()
                                            Symbols.arrow.padding()
                                        }
                                        
                                    }
                                    .cornerRadius(10)
                                }
                            }
                        }
                        .padding()
                        
                    }, header: {
                        Text("Divisions")
                    })
                    
                }
                
            }
            .navigationTitle("Hi \((session.user?.data.name.components(separatedBy: " ")[0])!)!")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showSwap = true
                    }
                    label: {
                        Symbols.swap
                        Text("Swap")
                    }
                }
            }
            .onAppear {
                
                Task {
                    
                    do {
                        divisions = try await DivisionService.fetch(userId: session.user!.data.id, accessToken: session.accessToken!)
                        
                        affiliates = try await AffiliateService.fetch(userId: session.user!.data.id, accessToken: session.accessToken!)
                        
                        let me = Affiliate(id: (session.user?.data.id)!, name: (session.user?.data.name)!, email: (session.user?.data.email)!, energyPrice: (session.user?.data.energyPrice)!)
                        
                        affiliates.append(me)
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
            .alert("Swap Dashboard", isPresented: $showSwap, actions: {
                Button("Ok") {}
            }, message: {})
            
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
