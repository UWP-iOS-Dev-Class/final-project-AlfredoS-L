//
//  MainView.swift
//  iOS-TwoQ
//
//  Created by Alfredo Sandoval-Luis on 4/2/25.
//

import SwiftUI

// MARK: - MainView
// This is the main screen after logging in.
// It uses a TabView to let the user navigate between different sections of the app.

struct MainView: View {
    var body: some View {
        TabView {
            
            // MARK: - User Swiping Section
            // This is where users will swipe through cards of other users (dating app style).
            UserCardView()
                .tabItem {
                    Image(systemName: "binoculars.fill") // Icon for Explore
                }
                .tag(0)
            
            // MARK: - Matches Section
            // This is where users will see the people they've matched with.
            MatchesView()
                .tabItem {
                    Image(systemName: "tray.fill") // Icon for Matches
                }
                .tag(1)
            
            // MARK: - User Profile Section
            // This is where users can view and edit their profile/settings.
            UserProfileView()
                .tabItem {
                    Image(systemName: "person.fill") // Icon for Profile
                }
                .tag(2)
        }
        .tint(Color.primary) // Tint color applies to the selected tab's icon
    }
}

// MARK: - Preview
#Preview {
    MainView()
        .environmentObject(AuthViewModel()) // Needed because some tabs might use auth data
}
