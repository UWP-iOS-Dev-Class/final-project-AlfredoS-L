//
//  LoginView.swift
//  iOS-TwoQ
//
//  Created by Alfredo Sandoval-Luis on 4/2/25.
//

import SwiftUI

struct LoginView: View {
  @State private var email = ""
  @State private var password = ""
  @State private var isLoggedIn = false
  @State private var isRegistering = false
  
  var body: some View {
    NavigationStack {
      VStack {
        // App name
        Text("TwoQ")
          .font(.largeTitle)
          .fontWeight(.bold)
        
        Spacer().frame(height: 8)
        
        // Greeting text
        Text("Welcome Back!")
          .font(.title2)
          .foregroundColor(.gray)
        
        Spacer().frame(height: 40)
        
        // Email & password fields
        VStack(spacing: 16) {
          TextField("Email", text: $email)
            .keyboardType(.emailAddress)
            .textContentType(.emailAddress)
            .autocapitalization(.none)
            .disableAutocorrection(true)
            .padding()
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(8)
          
          SecureField("Password", text: $password)
            .padding()
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(8)
        }
        .padding(.horizontal, 32)
        
        Spacer().frame(height: 20)
        
        // Sign in button
        Button(action: {
          isLoggedIn = true
        }) {
          Text("Sign In")
            .bold()
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.orange)
            .cornerRadius(8)
        }
        .padding(.horizontal, 80)
        .padding(.top, 20)
        
        // Sign Up link
        HStack {
          Text("Not a current member?")
            .foregroundColor(.gray)
          Button(action: {
            isRegistering = true
          }) {
            Text("Sign up")
              .fontWeight(.bold)
          }
        }
        .padding(.bottom, 30)
        .padding(.top, 60)
      }
      // Push MainView
      .navigationDestination(isPresented: $isLoggedIn) {
        MainView()
        //.navigationBarBackButtonHidden(true)
      }
      // Push RegistrationView
      .navigationDestination(isPresented: $isRegistering) {
        RegistrationView()
      }
      .navigationBarHidden(true)
    }
  }
}

#Preview {
  LoginView()
}
