//
//  ARView.swift
//  SmartEnergyMonitoring
//
//  Created by Fábio Cordeiro Gaspar on 24/11/2022.
//

import SwiftUI

struct ARView: View {
    var body: some View {
        NavigationView {
            
            ZStack {
                
                Theme.background.edgesIgnoringSafeArea(.top) 
                
                Text("AR")
                
            }
            .navigationTitle("AR")
            
        }
    }
}

struct ARView_Previews: PreviewProvider {
    static var previews: some View {
        ARView()
    }
}
