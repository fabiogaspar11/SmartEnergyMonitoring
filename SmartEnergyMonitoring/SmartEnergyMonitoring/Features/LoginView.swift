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
                
                Button {
                    session.signIn([
                        "username": email,
                        "password": password
                    ])
                } label: {
                    PrimaryButton(title: "Next →")
                        .padding(.vertical)
                }
                
                Text("Don't have an account? Register here").foregroundColor(.orange)
                
                
            }
            .padding()
        }
    }

} 

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(SessionManager())
    }
}
