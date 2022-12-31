//
//  InvoiceListView.swift
//  SmartEnergyMonitoring
//
//  Created by Daniel Soares Carreira on 30/12/2022.
//

import SwiftUI
import Charts

struct InvoiceListView: View {
    @State private var userStats: UserStats = []
    @State private var isLoading: Bool = true
    
    @State private var userStatsData: [UserStatData] = []
    
    @State private var didFail = false
    @State private var failMessage = ""
    
    @EnvironmentObject var session: SessionManager
    
    enum ViewType: CaseIterable {
        case Graph
        case List
    }
    
    var body: some View {
        VStack {
            if (isLoading) {
                ProgressView()
            }
            else {
                Section {
                    VStack(alignment: .leading) {
                        Text("\(userStats.count == 0 ? "0.00" : userStats[0].value) kWh")
                            .font(.largeTitle.bold())
                        
                        Chart(userStatsData) {
                            BarMark(
                                x: .value("Time", $0.timestamp),
                                y: .value("Consumption (kWh)", $0.consumption)
                            )
                        }
                        .frame(height: 260)
                    }
                    .padding()
                    
                    List {
                        ForEach(userStats, id: \.timestamp) { userStat in
                            HStack {
                                Text("\(userStat.timestamp)")
                                Spacer()
                                Text("\(userStat.value) kWh")
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }
        }
        .onAppear() {
            Task {
                do {
                    if (userStatsData.count > 0) { return }
                    isLoading = true
                    userStats = try await UserStatService.fetchAll(userId: (session.user?.data.id)!, accessToken: session.accessToken!)
                    userStats.forEach { userStat in
                        userStatsData.append(userStat.toUserStatData())
                    }
                    isLoading = false
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
    }
}
