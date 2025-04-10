//
//  AuthViewModel.swift
//  iOS-TwoQ
//
//  Created by Alfredo Sandoval-Luis on 4/2/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class AuthViewModel: ObservableObject {
  // Properties for tracking the current user and login state
  @Published var user: FirebaseAuth.User?
  @Published var isLoggedIn: Bool = false
  @Published var errorMessage: String?
  
  private let auth = Auth.auth()
  private let db = Firestore.firestore()
  
  init() {
    // Set current user if already logged in
    self.user = auth.currentUser
    self.isLoggedIn = auth.currentUser != nil
  }
  
  // Sign Up
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
      
      // Create a Firestore document for the new user.
      let userData: [String: Any] = [
        "id": user.uid,
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "region": region,
      ]
      
      self.db.collection("users").document(user.uid).setData(userData) { err in
        if let err = err {
          self.errorMessage = err.localizedDescription
          completion(false)
        } else {
          self.user = user
          self.isLoggedIn = true
          completion(true)
        }
      }
    }
  }
  
  // Sign In
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
  
  // Sign Out
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
