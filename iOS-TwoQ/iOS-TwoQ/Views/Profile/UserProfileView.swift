//
//  UserProfileView.swift
//  iOS-TwoQ
//

import SwiftUI
import FirebaseFirestore

// MARK: - Custom Remote Image Loader
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
        .onAppear {
            loadImage()
        }
        .onChange(of: url) {
            loadImage()
        }
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
        }.resume()
    }
}

// MARK: - UserProfileView
struct UserProfileView: View {
    @EnvironmentObject var authVM: AuthViewModel

    @State private var showEditProfile = false
    @State private var showPreferences = false

    @State private var firstName = ""
    @State private var lastName = ""
    @State private var photoURL: URL?

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                VStack(spacing: 8) {
                    RemoteImage(url: photoURL)

                    Text("\(firstName) \(lastName)".trimmingCharacters(in: .whitespaces))
                        .font(.headline)

                    Text(authVM.user?.email ?? "Email Unknown")
                        .font(.subheadline)
                        .foregroundColor(.gray)
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
                            }
                            .foregroundColor(.black)
                        }

                        Button {
                            showPreferences = true
                        } label: {
                            HStack {
                                Text("Matchmaking Preferences")
                                Spacer()
                                Image(systemName: "chevron.right")
                            }
                            .foregroundColor(.black)
                        }
                    }

                    Section {
                        Button {
                            authVM.signOut()
                        } label: {
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

                .navigationDestination(isPresented: $showEditProfile) {
                    EditProfileView()
                }
                .navigationDestination(isPresented: $showPreferences) {
                    MatchPreferencesView()
                }
            }
            .navigationTitle("Settings")
            .onAppear(perform: loadUserData)
        }
    }

    // MARK: - Load Name and Photo from Firestore
    private func loadUserData() {
        guard let uid = authVM.user?.uid else { return }

        Firestore.firestore().collection("users").document(uid).getDocument { document, error in
            if let document = document, document.exists {
                let data = document.data()
                self.firstName = data?["firstName"] as? String ?? ""
                self.lastName = data?["lastName"] as? String ?? ""

                if let urlString = data?["photoURL"] as? String {
                    self.photoURL = URL(string: urlString)
                }
            } else {
                print("Error loading user data: \(error?.localizedDescription ?? "unknown error")")
            }
        }
    }
}

// MARK: - Preview
#Preview {
    UserProfileView()
        .environmentObject(AuthViewModel())
}
