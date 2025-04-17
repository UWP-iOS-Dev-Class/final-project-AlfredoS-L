//
//  RegistrationView.swift
//  iOS-TwoQ
//
//  Created by Alfredo Sandoval-Luis on 4/2/25.
//

import SwiftUI

struct RegistrationView: View {
  
  @Environment(\.dismiss) var dismiss
  @EnvironmentObject var authVM: AuthViewModel
  
  @State private var firstName = ""
  @State private var lastName = ""
  @State private var region = ""
  @State private var email = ""
  @State private var password = ""
  @State private var confirmPassword = ""
  // Flag to trigger navigation on successful sign up.
  @State private var isRegistered = false
  
  var body: some View {
    VStack {
      Text("TwoQ")
        .font(.largeTitle)
        .fontWeight(.bold)
      
      Spacer().frame(height: 8)
      
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
        // Ensure passwords match, then try to sign up.
        guard password == confirmPassword else {
          // Error message to be added.
          return
        }
        authVM.signUp(firstName: firstName,
                      lastName: lastName,
                      email: email,
                      password: password,
                      region: region) { success in
          if success {
            isRegistered = true // Trigger navigation to MainView.
          } else {
            // Error message to be added.
          }
        }
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
      
      // Already a member? Dismiss to go back to LoginView.
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
    // Navigation destination for successful registration.
    .navigationDestination(isPresented: $isRegistered) {
      MainView()
        .navigationBarBackButtonHidden(true)
    }
    .navigationBarHidden(true)
  }
}

#Preview {
  RegistrationView()
}
