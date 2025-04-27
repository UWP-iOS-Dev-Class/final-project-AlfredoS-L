//
//  RegistrationView.swift
//  iOS-TwoQ
//
//  Created by Alfredo Sandoval-Luis on 4/2/25.
//

import SwiftUI

// MARK: - RegistrationView
// This screen lets new users create an account by filling in their information.

struct RegistrationView: View {
    
    // MARK: - Environment
    @Environment(\.dismiss) var dismiss        // Lets us dismiss the RegistrationView
    @EnvironmentObject var authVM: AuthViewModel // Shared Authentication ViewModel
    
    // MARK: - User Input Fields
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var region = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    
    // MARK: - State Control
    @State private var isRegistered = false     // Used to navigate to MainView if sign up succeeds
    
    // MARK: - Body
    var body: some View {
        VStack {
            // App Title
            Text("TwoQ")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Spacer().frame(height: 8)
            
            // Form Fields
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
            
            // Sign Up Button
            Button(action: {
                // Validate that the password and confirmPassword match
                guard password == confirmPassword else {
                    // Optional: Add user-facing error alert
                    return
                }
                
                // Call AuthViewModel to perform sign up
                authVM.signUp(firstName: firstName,
                              lastName: lastName,
                              email: email,
                              password: password,
                              region: region) { success in
                    if success {
                        isRegistered = true // Trigger navigation to MainView
                    } else {
                        // Optional: Display authVM.errorMessage here in an alert
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
            
            // Navigate back to Login if already a member
            HStack {
                Text("Already a member?")
                    .foregroundColor(.gray)
                Button(action: {
                    dismiss() // Close RegistrationView
                }) {
                    Text("Sign in")
                        .fontWeight(.bold)
                }
            }
            .padding(.bottom, 30)
            .padding(.top, 60)
        }
        // Navigate to MainView automatically after successful registration
        .navigationDestination(isPresented: $isRegistered) {
            MainView()
                .navigationBarBackButtonHidden(true) // Hide back button in MainView
        }
        .navigationBarHidden(true) // Hide the default navigation bar on this screen
    }
}

// MARK: - Preview
#Preview {
    RegistrationView()
}
