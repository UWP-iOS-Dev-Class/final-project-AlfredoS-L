//
//  RegistrationView.swift
//  iOS-TwoQ
//
//  Created by Alfredo Sandoval-Luis on 4/2/25.
//

import SwiftUI

// MARK: - RegistrationView
// Collects only email and password; navigation is now driven by AuthState in ContentView.

struct RegistrationView: View {
    
    // Environment for dismissing back to LoginView
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authVM: AuthViewModel
    
    // Input Fields
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    
    var body: some View {
        VStack {
            Text("TwoQ")
                .font(.largeTitle)
                .fontWeight(.bold)

            Spacer().frame(height: 8)
            
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

                SecureField("Confirm Password", text: $confirmPassword)
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(8)
            }
            .padding(.horizontal, 32)

            Spacer().frame(height: 20)
            
            // Sign Up action only triggers AuthViewModel.signUp; AuthState drives the next screen
            Button(action: {
                guard password == confirmPassword else {
                    // Optionally surface an error message here
                    return
                }
                authVM.signUp(email: email, password: password)
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

            HStack {
                Text("Already a member?")
                    .foregroundColor(.gray)
                Button("Sign in") {
                    dismiss()
                }
                .fontWeight(.bold)
            }
            .padding(.bottom, 30)
            .padding(.top, 60)
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    RegistrationView()
        .environmentObject(AuthViewModel())
}
