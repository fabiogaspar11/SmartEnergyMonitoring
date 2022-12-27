//
//  ConsumptionGraph.swift
//  SmartEnergyMonitoring
//
//  Created by Daniel Soares Carreira on 27/12/2022.
//

import SwiftUI
import Charts

struct ConsumptionGraph: View {
    @Binding var lastConsumption: Consumption?
    @Binding var consumptionData: [ConsumptionData]
    @Binding var consumptionsLoading: Bool
    
    var body: some View {
        Text("\(lastConsumption?.value ?? "0.00") W")
            .font(.largeTitle.bold())
        
        if (consumptionsLoading) {
            HStack {
                Spacer()
                ProgressView()
                    .padding(.bottom)
                Spacer()
            }
        }
        else {
            Chart(consumptionData) {
                LineMark(
                    x: .value("Time", $0.timestamp),
                    y: .value("Power (W)", $0.consumption)
                )
            }
            .frame(height: 260)
        }
    }
}
