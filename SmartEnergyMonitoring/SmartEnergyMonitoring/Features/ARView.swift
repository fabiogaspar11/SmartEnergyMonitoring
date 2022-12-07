//
//  ARView.swift
//  SmartEnergyMonitoring
//
//  Created by Fábio Cordeiro Gaspar on 24/11/2022.
//

import SwiftUI
import WebKit

struct ARView: View {
    
    @EnvironmentObject var session: SessionManager
    
    var body: some View {
        NavigationView {
            
            ZStack {
                
                Theme.background.edgesIgnoringSafeArea(.top)
                SwiftUIWebView(accessToken: "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIyIiwianRpIjoiYWM4ZjExYzRhMzg1NjBiYjhmZDcxOTVkOWRiZDhiN2ZiMmJjNGM3OWYzODc4M2E1MzExNzA5ZTY0YWUxZTE1ZGIyMzU2OWZlNDVmMGUxNDkiLCJpYXQiOjE2NzA0MzM1MTAuODU5OTA4LCJuYmYiOjE2NzA0MzM1MTAuODU5OTEsImV4cCI6MTcwMTk2OTUxMC44NTMyNzUsInN1YiI6IjEiLCJzY29wZXMiOltdfQ.nge5vfy5LJtWbvRQoZzGFAY3S71_-vIO69XHZ62oBPas_kWXk4XRhAGzXRt_5hAGkZ-WZegWN-iUe-ZEhltbZSe-h9yokTObGXTPaTD7f4cyw2s_fkp2XYyNqOXgpsQfohXHN6_R9CWNnOuclUaAmvpQ9g9_crywmF1jibIEshZHoFo3FTkYaWoEX14gTvPHfv3GTmZrOdQr74rJIjOAwUwfkANisVMs-6IggYqnQZRdQo1Rlndc6TymLXjpdMAUsg9Zbl2-ccgALJiXO4Jx13VjEoREw82pNJ5Rgk3-TwIjlKhJzLw4jVner1zPiRby7_Jr4Oj1aR3-xxhyJYKWw_LyEylSnkwa6nPEuQYiCJLHYGf6SfCc2DYooOj2XOGA-HXDdkyXk8AIhXmbi1ZiiXSvhRxuXJUEkV8LSRmDUyIzKi1gxuh5DwBEIURlH6AUt4_0ljS396Yo5HCWtAzijsIoFIf1nRufqZ6Z313ClvyWG9gJaTHi6c5xTV2_tDB9-At1g4tUH8Q_FfAxVTynE7XYSVfIH-ngIf9JQl4fH2R0Bose_gQoeaKpTlwQO9lhiDIlW0z4AnP_zya5PqqvdAP64n40gROnpH5Q-8EheQpry5yn2CXwzF0dSPKmlzp8V82nwxaJwn5gGnnfqg77YJXfz5uPhooXmtqMNl-G0mk")
                
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
