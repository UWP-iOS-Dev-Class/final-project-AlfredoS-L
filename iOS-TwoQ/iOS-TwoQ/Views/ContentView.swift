//
//  ContentView.swift
//  iOS-TwoQ
//
//  Created by Alfredo Sandoval-Luis on 4/2/25.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var authVM = AuthViewModel()
    
    var body: some View {
        switch authVM.authState {
        case .signedOut:
            // Show login/sign‑up flow
            LoginView()
                .environmentObject(authVM)
            
        case .signedInButIncomplete:
            // User created account but hasn't completed profile
            CompleteProfileView()
                .environmentObject(authVM)
            
        case .signedIn:
            // Fully onboarded: show main app
            MainView()
                .environmentObject(authVM)
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthViewModel())
}
