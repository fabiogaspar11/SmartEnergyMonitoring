//
//  SettingsView.swift
//  SmartEnergyMonitoring
//
//  Created by Fábio Cordeiro Gaspar on 24/11/2022.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationView {
            
            ZStack {
                
                Theme.background.edgesIgnoringSafeArea(.top) 
                
                Text("Settings")
                
            }
            .navigationTitle("Settings")
            
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
