//
//  UserProfileView.swift
//  iOS-TwoQ
//

import SwiftUI
import FirebaseFirestore

// MARK: - Custom Remote Image Loader
// (If you’re not using RemoteImage anywhere else, you can delete this)
struct RemoteImage: View {
    let url: URL?
    @State private var image: Image? = nil

    var body: some View {
        Group {
            if let image = image {
                image
                    .resizable()
                    .scaledToFill()
            } else {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.orange.opacity(0.4))
            }
        }
        .frame(width: 80, height: 80)
        .clipShape(Circle())
        .onAppear { loadImage() }
        .onChange(of: url) { _ in loadImage() }
    }

    private func loadImage() {
        guard let url = url else { return }
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data,
                  let uiImage = UIImage(data: data) else {
                print("Failed to load image:", error?.localizedDescription ?? "no data")
                return
            }
            DispatchQueue.main.async {
                self.image = Image(uiImage: uiImage)
            }
        }
        .resume()
    }
}

// MARK: - UserProfileView
struct UserProfileView: View {
    // MARK: - Environment
    @EnvironmentObject var authViewModel: AuthViewModel

    // MARK: - Navigation State
    @State private var showEditProfile = false
    @State private var showPreferences = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
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

                List {
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
            .background(Color("backgroundColor"))
        }
    }
}

// MARK: - Preview
#Preview {
    UserProfileView()
        .environmentObject(AuthViewModel())
}
