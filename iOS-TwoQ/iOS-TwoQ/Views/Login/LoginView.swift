//
//  LoginView.swift
//  iOS-TwoQ
//
//  Created by Alfredo Sandoval-Luis on 4/2/25.
//

import SwiftUI

// MARK: - LoginView
// This screen allows users to sign into their existing accounts or navigate to sign up.

struct LoginView: View {
    
    // MARK: - Environment
    @EnvironmentObject var authVM: AuthViewModel // Shared Authentication ViewModel
    
    // MARK: - User Input Fields
    @State private var email = ""
    @State private var password = ""
    
    // MARK: - State Control
    @State private var isRegistering = false // Used to navigate to RegistrationView
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            VStack {
                
                // MARK: - App Title
                Text("TwoQ")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Spacer().frame(height: 8)
                
                Text("Welcome Back!")
                    .font(.title2)
                    .foregroundColor(.gray)
                
                Spacer().frame(height: 40)
                
                // MARK: - Email and Password Fields
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
                
                // MARK: - Sign In Button
                Button(action: {
                    authVM.signIn(email: email, password: password) { success in
                        // authVM.isLoggedIn will automatically trigger ContentView to show MainView.
                    }
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
                
                // MARK: - Link to Registration
                HStack {
                    Text("Not a current member?")
                        .foregroundColor(.gray)
                    
                    Button(action: {
                        isRegistering = true // Open RegistrationView
                    }) {
                        Text("Sign up")
                            .fontWeight(.bold)
                    }
                }
                .padding(.bottom, 30)
                .padding(.top, 60)
            }
            // Navigate to RegistrationView if isRegistering becomes true
            .navigationDestination(isPresented: $isRegistering) {
                RegistrationView()
            }
            .navigationBarHidden(true) // Hide back button and nav bar on Login
        }
    }
}

// MARK: - Preview
#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
}
