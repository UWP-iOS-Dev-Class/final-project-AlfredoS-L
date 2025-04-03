//
//  RegistrationView.swift
//  iOS-TwoQ
//
//  Created by Alfredo Sandoval-Luis on 4/2/25.
//

import SwiftUI

struct RegistrationView: View {
  @Environment(\.dismiss) var dismiss
  @State private var firstName = ""
  @State private var lastName = ""
  @State private var region = ""
  @State private var email = ""
  @State private var password = ""
  @State private var confirmPassword = ""
  @State private var isRegistered = false
  
  var body: some View {
    VStack {
      // App name
      Text("TwoQ")
        .font(.largeTitle)
        .fontWeight(.bold)
      
      Spacer().frame(height: 8)
      
      // Registration fields
      VStack(spacing: 16) {
        TextField("First Name", text: $firstName)
          .padding()
          .background(Color(UIColor.secondarySystemBackground))
          .cornerRadius(8)
        
        TextField("Last Name", text: $lastName)
          .padding()
          .background(Color(UIColor.secondarySystemBackground))
          .cornerRadius(8)
        
        TextField("Region", text: $region)
          .padding()
          .background(Color(UIColor.secondarySystemBackground))
          .cornerRadius(8)
        
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
        
        SecureField("Confirm Password", text: $confirmPassword)
          .padding()
          .background(Color(UIColor.secondarySystemBackground))
          .cornerRadius(8)
      }
      .padding(.horizontal, 32)
      
      Spacer().frame(height: 20)
      
      // Sign Up button
      Button(action: {
        isRegistered = true
      }) {
        Text("Sign Up")
          .bold()
          .foregroundColor(.white)
          .padding()
          .frame(maxWidth: .infinity)
          .background(Color.orange)
          .cornerRadius(8)
      }
      .padding(.horizontal, 80)
      .padding(.top, 20)
      
      // Sign in link
      HStack {
        Text("Already a member?")
          .foregroundColor(.gray)
        Button(action: {
          dismiss()
        }) {
          Text("Sign in")
            .fontWeight(.bold)
        }
      }
      .padding(.bottom, 30)
      .padding(.top, 60)
    }
    // Push MainView
    .navigationDestination(isPresented: $isRegistered) {
      MainView()
      //.navigationBarBackButtonHidden(true)
    }
    .navigationBarHidden(true)
  }
}

#Preview {
  RegistrationView()
}
