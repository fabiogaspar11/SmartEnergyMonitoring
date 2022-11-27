//
//  DashboardView.swift
//  SmartEnergyMonitoring
//
//  Created by Fábio Cordeiro Gaspar on 24/11/2022.
//

import SwiftUI

struct DashboardView: View {
    
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 10), count: 2)
    @State var showSheet = false
    var body: some View {
        NavigationView {
            
            ZStack {
                
                Theme.background.edgesIgnoringSafeArea(.top) 
                
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(0...5, id: \.self) { item in
                            Button {
                                showSheet.toggle()
                            } label: {
                                ZStack {
                                    
                                    Color.white
                                    
                                    VStack() {
                                        
                                        Text("Kitchen")
                                            .font(.system(size: 22, weight: .bold))
                                            .foregroundColor(Theme.primary)
                                            .padding()
                                        
                                        Text("30 W")
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
                    .sheet(isPresented: $showSheet) {
                        Text("puta")
                    }
                }
                .padding()
                
            }
            .navigationTitle("Dashboard")
//            .toolbar {
//                ToolbarItem(placement: .primaryAction) {
//                    Button {}
//                    label: {
//                        Symbols.eye
//                    }
//                }
//            }
            
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
