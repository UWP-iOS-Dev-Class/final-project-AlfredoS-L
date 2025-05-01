//
//  UserProfileView.swift
//  iOS-TwoQ
//
//  Created by Alfredo Sandoval-Luis on 4/2/25.
//

import SwiftUI

// MARK: - UserProfileView
// This screen displays the user's profile information and provides navigation to edit profile, preferences, or logout.

struct UserProfileView: View {
    
    // MARK: - Environment
    @EnvironmentObject var authVM: AuthViewModel  // Access authentication information
    
    // MARK: - Navigation State
    @State private var showEditProfile = false     // Controls navigation to EditProfileView
    @State private var showPreferences = false     // Controls navigation to MatchPreferencesView
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                
                // MARK: - Profile Image and Info Section
                VStack(spacing: 8) {
                    AsyncImage(url: authVM.user?.photoURL) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 80, height: 80)
                                .clipShape(Circle())
                        default:
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                                .foregroundColor(.orange.opacity(0.4))
                        }
                    }
                    
                    Text(authVM.user?.displayName ?? "No Name")
                        .font(.headline)
                    
                    Text(authVM.user?.email ?? "Email Unknown")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.top, 20)
                
                // MARK: - Options List Section
                List {
                    
                    // Navigation Options
                    Section {
                        Button {
                            showEditProfile = true
                        } label: {
                            HStack {
                                Text("Edit Profile")
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                        }
                        .foregroundColor(.primary)
                        
                        Button {
                            showPreferences = true
                        } label: {
                            HStack {
                                Text("Matchmaking Preferences")
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                        }
                        .foregroundColor(.primary)
                    }
                    
                    // Logout Option
                    Section {
                        Button(action: {
                            authVM.signOut()
                        }) {
                            HStack {
                                Text("Logout")
                                Spacer()
                                Image(systemName: "arrow.right.square")
                            }
                        }
                        .foregroundColor(.red)
                    }
                }
                .listStyle(.insetGrouped)
                
                // MARK: - Navigation Destinations
                .navigationDestination(isPresented: $showEditProfile) {
                    EditProfileView()
                }
                .navigationDestination(isPresented: $showPreferences) {
                    MatchPreferencesView()
                }
            }
            .navigationTitle("Settings")
        }
    }
}

// MARK: - Preview
#Preview {
    UserProfileView()
        .environmentObject(AuthViewModel())
}
