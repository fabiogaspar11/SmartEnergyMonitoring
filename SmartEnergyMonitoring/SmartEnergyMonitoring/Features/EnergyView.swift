//
//  EnergyView.swift
//  SmartEnergyMonitoring
//
//  Created by Daniel Soares Carreira on 10/12/2022.
//

import SwiftUI

struct EnergyView: View {
    
    @EnvironmentObject var session: SessionManager
    
    var body: some View {
        
        NavigationStack {
            
            ZStack {
                
                Theme.background.edgesIgnoringSafeArea(.top)
                
                List {
                    
                    
                    
                }
                
            }
            .navigationTitle("Settings")
            .onAppear() {
                
                
                
            }
        }
    }
}

struct EnergyView_Previews: PreviewProvider {
    static var previews: some View {
        EnergyView()
    }
}