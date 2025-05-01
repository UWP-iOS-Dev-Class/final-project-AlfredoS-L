//
//  ContentView.swift
//  iOS-TwoQ
//
//  Created by Alfredo Sandoval-Luis on 4/2/25.
//

import SwiftUI

// MARK: - ContentView
// This view decides what the user sees based on whether they are logged in or not.

struct ContentView: View {
    
    // Using @StateObject to manage authentication across the app
    @StateObject var authVM = AuthViewModel()
    
    var body: some View {
        Group {
            if authVM.isLoggedIn {
                // If the user is logged in, show the MainView (Tab bar with app features)
                MainView()
                    .environmentObject(authVM) // Pass authVM to all subviews that need it
            } else {
                // If not logged in, show the Login screen
                LoginView()
                    .environmentObject(authVM)
            }
        }
    }
}

// MARK: - Preview
#Preview {
    ContentView()
}
