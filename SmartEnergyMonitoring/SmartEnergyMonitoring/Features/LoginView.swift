//
//  LoginView.swift
//  SmartEnergyMonitoring
//
//  Created by Fábio Cordeiro Gaspar on 05/10/2022.
//

import SwiftUI


struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    
    @State private var didFail = false
    @State private var failMessage = ""
    
    @EnvironmentObject var session: SessionManager
    
    var body: some View {
        ZStack {
            Color(.white).edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 290)
                    .scaledToFit()
                Spacer()
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .textContentType(.emailAddress)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .padding(.horizontal)
                    .font(.title3)
                    .foregroundColor(.orange)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.white)
                    .cornerRadius(15)
                    .shadow(color: .orange, radius: 1)
                    .padding(.top)
                
                SecureField("Password", text: $password)
                    .padding(.horizontal)
                    .font(.title3)
                    .foregroundColor(.orange)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.white)
                    .cornerRadius(15)
                    .shadow(color: .orange, radius: 1)
                    .padding(.top)
                
                Button(action: {
                    Task {
                        do {
                            try await session.signIn([
                                "username": email,
                                "password": password
                            ])
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
                    
                }, label: {
                    PrimaryButton(title: "Next →")
                        .padding(.vertical)
                })
                .alert("Authentication failed", isPresented: $didFail, actions: {
                    Button("Retry") {
                        password = ""
                    }	
                }, message: {
                    Text(failMessage)
                })
                
                Button(action: {
                    session.register()
                }, label: {
                    Text("Don't have an account? Register here").foregroundColor(.orange)
                })
    
            }
            .padding()
        }
        .onAppear {
            Task {
                
                try await session.rememberLogin()
                
            }
        }
    }

} 

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(SessionManager())
    }
}
