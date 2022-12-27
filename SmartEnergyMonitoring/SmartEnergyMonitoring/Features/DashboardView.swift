//
//  DashboardView.swift
//  SmartEnergyMonitoring
//
//  Created by Fábio Cordeiro Gaspar on 24/11/2022.
//

import SwiftUI
import Charts

struct DashboardView: View {
    
    @State private var divisions: Divisions?
    @State private var divisionsLoading = true
    @State private var activeDivisions: Set<DivisionShort> = []
    @State var observation: Observation?
    @State private var observationLoading = true
    @State var userStats: UserStats?
    @State private var userStatsLoading = true
    @State var consumptions: Consumptions?
    @State private var consumptionsLoading = true
    
    @State var lastConsumption: Consumption?
    
    @State var kWh = 0.0
    @State var month = ""
    @State var kWhDifference = 0.0
    @State var priceDifference = 0.0
    
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 10), count: 2)
    
    @State private var didFail = false
    @State private var failMessage = ""
    
    @State private var selectedView: Int = 0
    @State private var affiliates: Affiliates = []
    
    @State private var selectedViewType: ViewType = .Instant
    
    @State private var showSwap = false
    @State private var showSwapToolbar = false
    
    @EnvironmentObject var session: SessionManager
    
    enum ViewType: CaseIterable {
        case Instant
        case Day
        case Month
    }
    
    struct ConsumptionData: Identifiable {
        let id = UUID()
        let consumption: Double
        let timestamp: Date
        
        init(consumption: String, timestamp: Int) {
            self.consumption = Double(consumption)!
            self.timestamp = Date(timeIntervalSince1970: Double(timestamp))
        }
    }
    
    @State private var consumptionInstantData: [ConsumptionData] = []
    
    func loadStore() {
        Task {
            
            do {
                divisionsLoading = true
                observationLoading = true
                consumptionsLoading = true
                userStatsLoading = true
                
                // Fetch Divisions
                divisions = try await DivisionService.fetch(userId: selectedView, accessToken: session.accessToken!)
                divisionsLoading = false
                
                // Fetch Consumptions
                consumptions = try await ConsumptionService.fetch(userId: selectedView, accessToken: session.accessToken!)
                lastConsumption = consumptions?.data[0]
                consumptionsLoading = false
                consumptions?.data.forEach { consumption in
                    let consumptionData = ConsumptionData(consumption: consumption.value, timestamp: consumption.timestamp)
                    consumptionInstantData.append(consumptionData)
                }
                
                // Fetch Last Observation
                observation = try await ObservationService.fetchLast(userId: selectedView, accessToken: session.accessToken!)
                observation?.observation.equipments.filter { $0.consumption != "0.00" }.forEach { equipment in
                    let division = DivisionShort(id: equipment.division, name: equipment.divisionName)
                    activeDivisions.insert(division)
                }
                observationLoading = false
                
                // Fetch User Stats
                userStats = try await UserStatService.fetch(userId: selectedView, accessToken: session.accessToken!)
                kWh = Double((userStats?[0].value)!) ?? 0
                month = userStats?[0].timestamp ?? ""
                kWhDifference = Double((userStats?[0].value)!) ?? 0 - Double((userStats?[1].value)!)!
                priceDifference = Double((session.user?.data.energyPrice)!)! * kWhDifference
                userStatsLoading = false
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
    
    var body: some View {
        
        NavigationStack {
            
            ZStack {
                
                Theme.background.edgesIgnoringSafeArea(.top)
                
                List {
                    
                    Section {
                        
                        // Consumption Graph
                        VStack(alignment: .leading) {
                            Picker("Consumption", selection: $selectedViewType) {
                                Text("Now").tag(ViewType.Instant)
                                Text("Day").tag(ViewType.Day)
                                Text("Month").tag(ViewType.Month)
                            }
                            .pickerStyle(.segmented)
                            
                            switch(selectedViewType) {
                            case .Instant:
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
                                    Chart(consumptionInstantData) {
                                        LineMark(
                                            x: .value("Time", $0.timestamp),
                                            y: .value("Power (W)", $0.consumption)
                                        )
                                    }
                                    .frame(height: 260)
                                }
                                
                                
                            case .Day:
                                Chart(consumptionInstantData) {
                                    LineMark(
                                        x: .value("Time", $0.timestamp),
                                        y: .value("Power (W)", $0.consumption)
                                    )
                                }
                                .frame(height: 230)
                            default:
                                Chart(consumptionInstantData) {
                                    LineMark(
                                        x: .value("Time", $0.timestamp),
                                        y: .value("Power (W)", $0.consumption)
                                    )
                                }
                                .frame(height: 230)
                            }
                        }
                    }
                    
                    
                    Section(content: {
                        if (observationLoading) {
                            HStack {
                                Spacer()
                                ProgressView()
                                Spacer()
                            }
                        }
                        else {
                            
                            Button(action: {
                                
                            }, label: {
                                
                                HStack {
                                    Text("Equipments")
                                    Spacer()
                                    if (observationLoading) {
                                        ProgressView()
                                    }
                                    else {
                                        Text("\(observation?.observation.equipments.filter{ $0.consumption != "0.00" }.count ?? 0)")
                                            .foregroundStyle(.secondary)
                                    }
                                }
                            })
                            
                        }
                        
                    }, header: {
                        HStack {
                            Text("Energy")
                            Spacer()
                            Button(action: {
                                
                            },
                            label: {
                                Text("Show All")
                                    .font(.system(size: 14))
                            })
                        }
                    }, footer: {
                        
                    })
                    
                    
                    Section(content: {
                        
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Energy")
                                HStack {
                                    // Percentagem Difference
                                    Text("\(String(format: "%.2f", kWhDifference))")
                                        .font(.system(size: 15, weight: .bold))
                                        .foregroundStyle(Theme.textBadge)
                                        .padding(3)
                                        .background(kWhDifference > 0 ? .red : (kWhDifference < 0 ? .green : .gray))
                                        .cornerRadius(5)
                                    
                                    // Amount Difference
                                }
                            }
                            Spacer()
                            if (userStatsLoading) {
                                ProgressView()
                            }
                            else {
                                Text("\(String(format: "%.2f", kWh)) kWh")
                                    .foregroundStyle(.secondary)

                            }
                        }
                        
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Price")
                                HStack {
                                    Text("\(String(format: "%.2f", priceDifference))")
                                        .font(.system(size: 15, weight: .bold))
                                        .foregroundStyle(Theme.textBadge)
                                        .padding(3)
                                        .background(priceDifference > 0 ? .red : (priceDifference < 0 ? .green : .gray))
                                        .cornerRadius(5)
                                }
                            }
                            Spacer()
                            if (userStatsLoading) {
                                ProgressView()
                            }
                            else {
                                Text("\(String(format: "%.2f", Double((session.user?.data.energyPrice)!)! * kWh)) €")
                                    .foregroundStyle(.secondary)
                            }
                        }
                        
                    },
                    header: {
                        HStack {
                            Text("Invoice")
                            Spacer()
                            Button(action: {
                                
                            },
                            label: {
                                Text("Show All")
                                    .font(.system(size: 14))
                            })
                        }
                    },
                    footer: {
                        HStack {
                            Spacer()
                            Text(month)
                        }
                    })
                    
                }
                
            }
            .navigationTitle("Hi \((session.user?.data.name.components(separatedBy: " ")[0])!)!")
            .toolbar {
                if (showSwapToolbar) {
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
            }
            .onAppear {
                // Initial Dashboard
                selectedView = session.user!.data.id
                
                Task {
                    
                    do {
                        // Fetch Affiliates
                        affiliates = try await AffiliateService.fetch(userId: (session.user?.data.id)!, accessToken: session.accessToken!)
                        let me = Affiliate(id: (session.user?.data.id)!, name: (session.user?.data.name)!, email: (session.user?.data.email)!, energyPrice: (session.user?.data.energyPrice)!)
                        affiliates.insert(me, at: 0)
                        showSwapToolbar = affiliates.count > 1
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
                
                // Load Store
                loadStore()
            }
            .alert("Data fetch failed", isPresented: $didFail, actions: {
                Button("Ok") {}
            }, message: {
                Text(failMessage)
            })
            .alert("Swap Dashboard", isPresented: $showSwap, actions: {
                ForEach(affiliates.filter { $0.id != selectedView }) { affiliate in
                    Button(affiliate.name) {
                        selectedView = affiliate.id
                        loadStore()
                    }
                }
                Button("Cancel", role: .cancel) {}
            }, message: {})
            
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
