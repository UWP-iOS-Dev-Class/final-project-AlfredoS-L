//
//  AuthViewModel.swift
//  iOS-TwoQ
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import Combine

enum AuthState {
    case signedOut
    case signedInButIncomplete
    case signedIn
}

class AuthViewModel: ObservableObject {
    
    // 1) keep the FirebaseAuth user around
    @Published var user: FirebaseAuth.User?
    // 2) add your Firestore-backed User model
    @Published var appUser: User?
    @Published var authState: AuthState = .signedOut
    @Published var errorMessage: String?
    
    private let auth = Auth.auth()
    private let db   = Firestore.firestore()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // grab the existing FirebaseAuth user
        self.user = auth.currentUser
        
        if let uid = user?.uid {
            // check their profileComplete flag (your existing helper)
            checkProfile(for: uid)
            // **NEW** load their full Firestore User doc
            loadAppUser(for: uid)
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
                    // **NEW** immediately attempt to load their document (it exists, even if incomplete)
                    self.loadAppUser(for: user.uid)
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
            // check profileComplete like before…
            self.checkProfile(for: user.uid)
            // **NEW** load their Firestore User model so you can pass it into MatchService
            self.loadAppUser(for: user.uid)
            
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
            appUser   = nil     // clear out your Firestore User as well
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
    
    // ——— NEW METHOD ———
    /// Loads the Firestore `users/{uid}` doc into your own `User` struct
    private func loadAppUser(for uid: String) {
        db.collection("users").document(uid).getDocument { [weak self] snapshot, error in
            guard let self = self else { return }
            if let error = error {
                print("❌ loadAppUser error:", error)
                return
            }
            guard let snapshot = snapshot, snapshot.exists else {
                print("⚠️ no user doc for uid:", uid)
                return
            }
            
            do {
                // requires `import FirebaseFirestoreSwift`
                self.appUser = try snapshot.data(as: User.self)
            } catch {
                print("❌ decoding User failed:", error)
            }
        }
    }
}

