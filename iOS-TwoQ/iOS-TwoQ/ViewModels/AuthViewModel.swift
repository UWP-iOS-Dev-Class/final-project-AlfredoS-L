//
//  AuthViewModel.swift
//  iOS-TwoQ
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

enum AuthState {
    case signedOut
    case signedInButIncomplete
    case signedIn
}

class AuthViewModel: ObservableObject {
    
    @Published var user: FirebaseAuth.User?
    @Published var authState: AuthState = .signedOut
    @Published var errorMessage: String?
    
    private let auth = Auth.auth()
    private let db   = Firestore.firestore()
    
    init() {
        self.user = auth.currentUser
        if let uid = user?.uid {
            checkProfile(for: uid)
        } else {
            authState = .signedOut
        }
    }
    
    func signUp(email: String, password: String) {
        auth.createUser(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else { return }
            if let error = error {
                self.errorMessage = error.localizedDescription
                return
            }
            guard let user = result?.user else {
                self.errorMessage = "User creation failed"
                return
            }
            
            // create the user document with profileComplete = false
            let userData: [String: Any] = [
                "id":              user.uid,
                "email":           email,
                "photoURL":        "",
                "tags":            [],
                "profileComplete": false
            ]
            
            self.db.collection("users").document(user.uid).setData(userData) { err in
                if let err = err {
                    self.errorMessage = err.localizedDescription
                } else {
                    self.user = user
                    self.authState = .signedInButIncomplete
                }
            }
        }
    }
    
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
            self.checkProfile(for: user.uid)
            
            completion(true)
        }
    }
    
    func finishOnboarding() {
        authState = .signedIn
    }
    
    func signOut() {
        do {
            try auth.signOut()
            user      = nil
            authState = .signedOut
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    // MARK: ——————————————————————————————
    private func checkProfile(for uid: String) {
        db.collection("users").document(uid).getDocument { [weak self] doc, error in
            guard let self = self else { return }
            if let data = doc?.data(),
               let complete = data["profileComplete"] as? Bool,
               complete {
                self.authState = .signedIn
            } else {
                self.authState = .signedInButIncomplete
            }
        }
    }
}
