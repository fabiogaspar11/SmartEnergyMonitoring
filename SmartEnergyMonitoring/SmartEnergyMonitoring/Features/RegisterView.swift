//
//  RegisterView.swift
//  SmartEnergyMonitoring
//
//  Created by Fábio Cordeiro Gaspar on 05/10/2022.
//

import SwiftUI

struct RegisterView: View {
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var birthdate = Date()
    
    @State private var didFail = false
    @State private var failMessage = ""
    
    @EnvironmentObject var session: SessionManager
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("Hi!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.orange)
            
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
            
            TextField("Full Name", text: $name)
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
                .padding(.vertical)
            
            DatePicker("Birthdate", selection: $birthdate, displayedComponents: .date)
                .padding(.horizontal)
                .font(.title3)
                .foregroundColor(.orange)
                .padding()
                .frame(maxWidth: .infinity)
                .background(.white)
                .cornerRadius(15)
                .shadow(color: .orange, radius: 1)
                
            
            Button(action: {
                Task{
                    do {
                        let dateFormatterGet = DateFormatter()
                        dateFormatterGet.dateFormat = "dd/MM/yyyy"
                        
                        let _ = try await UserService.create(parameters: [
                            "name": name,
                            "email":email,
                            "password":password,
                            "birthdate":dateFormatterGet.string(from: birthdate)
                        ])
                        
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
                    .padding(.top)
            })
            .alert("Registration failed", isPresented: $didFail, actions: {
                Button("Retry") {
                    password = ""
                }
            }, message: {
                Text(failMessage)
            })
            
        }
        .padding()
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
            .environmentObject(SessionManager())
    }
}
