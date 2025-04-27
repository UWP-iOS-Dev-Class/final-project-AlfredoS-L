//
//  AuthViewModel.swift
//  iOS-TwoQ
//
//  Created by Alfredo Sandoval-Luis on 4/2/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

// MARK: - Authentication ViewModel
// This ViewModel handles all authentication logic: sign up, sign in, sign out, and error handling.

class AuthViewModel: ObservableObject {
    
    // MARK: - Published Properties
    // These variables update the SwiftUI UI whenever their values change.
    @Published var user: FirebaseAuth.User?          // The currently authenticated Firebase user
    @Published var isLoggedIn: Bool = false          // True if the user is signed in
    @Published var errorMessage: String?             // Error message to show in UI if something goes wrong
    
    // MARK: - Private Firebase Properties
    private let auth = Auth.auth()                   // Firebase Authentication instance
    private let db = Firestore.firestore()           // Firestore Database instance
    
    // MARK: - Initializer
    init() {
        // Set the user if already logged in when the app starts
        self.user = auth.currentUser
        self.isLoggedIn = auth.currentUser != nil
    }
    
    // MARK: - Sign Up Method
    /// Creates a new user account and saves basic user info into Firestore.
    func signUp(firstName: String,
                lastName: String,
                email: String,
                password: String,
                region: String,
                completion: @escaping (Bool) -> Void) {
        
        auth.createUser(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else { return }
            
            if let error = error {
                self.errorMessage = error.localizedDescription
                completion(false)
                return
            }
            
            guard let user = result?.user else {
                self.errorMessage = "User creation failed"
                completion(false)
                return
            }
            
            // Set up Firestore user document
            let userData: [String: Any] = [
                "id": user.uid,
                "firstName": firstName,
                "lastName": lastName,
                "email": email,
                "region": region,
                "photoURL": "" // Empty for now; user can upload later
            ]
            
            self.db.collection("users").document(user.uid).setData(userData) { err in
                if let err = err {
                    self.errorMessage = err.localizedDescription
                    completion(false)
                } else {
                    // Optionally, update the FirebaseAuth user's display name
                    let changeRequest = user.createProfileChangeRequest()
                    changeRequest.displayName = "\(firstName) \(lastName)"
                    changeRequest.commitChanges { error in
                        if let error = error {
                            print("Failed to set display name: \(error.localizedDescription)")
                        }
                    }
                    
                    self.user = user
                    self.isLoggedIn = true
                    completion(true)
                }
            }
        }
    }
    
    // MARK: - Sign In Method
    /// Signs an existing user into the app using email and password.
    func signIn(email: String, password: String, completion: @escaping (Bool) -> Void) {
        auth.signIn(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else { return }
            
            if let error = error {
                self.errorMessage = error.localizedDescription
                completion(false)
                return
            }
            
            guard let user = result?.user else {
                self.errorMessage = "Sign in failed"
                completion(false)
                return
            }
            
            self.user = user
            self.isLoggedIn = true
            completion(true)
        }
    }
    
    // MARK: - Sign Out Method
    /// Signs the user out of Firebase and clears local state.
    func signOut() {
        do {
            try auth.signOut()
            self.user = nil
            self.isLoggedIn = false
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
}
