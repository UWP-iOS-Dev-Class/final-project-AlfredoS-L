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
    @EnvironmentObject var authViewModel: AuthViewModel  // Access authentication information
    
    // MARK: - Navigation State
    @State private var showEditProfile = false     // Controls navigation to EditProfileView
    @State private var showPreferences = false     // Controls navigation to MatchPreferencesView
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                
                // MARK: - Profile Image and Info Section
                VStack(spacing: 8) {
                    AsyncImage(url: authViewModel.user?.photoURL) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 80, height: 80)
                                .clipShape(Circle())
                        default:
                            SkeletonView(.circle)
                                .frame(width: 80, height: 80)
                        }
                    }
                    
                    Text(authViewModel.user?.displayName ?? "No Name")
                        .font(.headline)
                        .foregroundStyle(Color("textColor"))
                    
                    Text(authViewModel.user?.email ?? "Email Unknown")
                        .font(.subheadline)
                        .foregroundStyle(Color.gray)
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
                                    .foregroundStyle(Color("textColor"))
                            }
                        }
                        .foregroundStyle(Color("textColor"))
                        
                        Button {
                            showPreferences = true
                        } label: {
                            HStack {
                                Text("Matchmaking Preferences")
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundStyle(Color("textColor"))
                            }
                        }
                        .foregroundStyle(Color("textColor"))
                    }
                    
                    // Logout Option
                    Section {
                        Button(action: {
                            authViewModel.signOut()
                        }) {
                            HStack {
                                Text("Logout")
                                Spacer()
                                Image(systemName: "arrow.right.square")
                            }
                        }
                        .foregroundStyle(.red)
                    }
                }
                
                // MARK: - Navigation Destinations
                .navigationDestination(isPresented: $showEditProfile) {
                    EditProfileView()
                }
                .navigationDestination(isPresented: $showPreferences) {
                    MatchPreferencesView()
                }
            }
            .background(Color("backgroundColor"))
        }
    }
}

// MARK: - Preview
#Preview {
    UserProfileView()
        .environmentObject(AuthViewModel())
}
