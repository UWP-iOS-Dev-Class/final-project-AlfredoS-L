//
//  CompleteProfileView.swift
//  iOS-TwoQ
//
//  Created by Alfredo Sandoval-Luis on 4/2/25.
//

import SwiftUI
import Firebase
import FirebaseStorage
import PhotosUI

struct CompleteProfileView: View {
    @EnvironmentObject var authVM: AuthViewModel

    @State private var firstName = ""
    @State private var lastName = ""
    @State private var region = ""
    @State private var playRanked = false
    @State private var rank = ""
    @State private var mainAgent = ""

    @State private var selectedPhotoData: Data? = nil
    @State private var selectedItem: PhotosPickerItem? = nil

    @State private var isSaving = false

    let availableRanks = ["iron", "bronze", "silver", "gold", "platinum", "diamond", "ascendant", "immortal", "radiant"]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Complete Your Profile")
                        .font(.title)
                        .bold()

                    Text("Select an image for your profile:")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 4)

                    PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
                        if let data = selectedPhotoData, let uiImage = UIImage(data: data) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                        } else {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .scaledToFill()
                                .foregroundColor(.orange.opacity(0.4))
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                        }
                    }
                    .onChange(of: selectedItem) {
                        Task {
                            if let data = try? await selectedItem?.loadTransferable(type: Data.self) {
                                selectedPhotoData = data
                            }
                        }
                    }

                    Group {
                        TextField("First Name", text: $firstName)
                        TextField("Last Name", text: $lastName)
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(8)

                    Text("Select your region:")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 4)

                    Picker("Region", selection: $region) {
                        Text("North America").tag("North America")
                        Text("Europe").tag("Europe")
                        Text("Asia").tag("Asia")
                        Text("South America").tag("South America")
                        Text("Other").tag("Other")
                    }
                    .pickerStyle(.menu)
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(8)

                    Toggle("Do you play ranked?", isOn: $playRanked)

                    if playRanked {
                        Text("Select your rank:")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 4)

                        Picker("Rank", selection: $rank) {
                            ForEach(availableRanks, id: \.self) { rankOption in
                                Text(rankOption.uppercased()).tag(rankOption)
                            }
                        }
                        .pickerStyle(.menu)
                        .padding()
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(8)

                        TextField("Main agent", text: $mainAgent)
                            .padding()
                            .background(Color(UIColor.secondarySystemBackground))
                            .cornerRadius(8)
                    }

                    Button(action: saveProfile) {
                        if isSaving {
                            ProgressView()
                        } else {
                            Text("Complete Profile")
                                .bold()
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.orange)
                                .cornerRadius(8)
                        }
                    }
                    .padding(.horizontal, 80)
                    .padding(.top, 20)
                }
                .padding()
            }
            .navigationBarBackButtonHidden(true)
        }
    }

    private func saveProfile() {
        guard let user = authVM.user else { return }
        isSaving = true

        // Helper to upload photo if one was selected
        func uploadPhotoIfNeeded(completion: @escaping (String) -> Void) {
            guard let data = selectedPhotoData else {
                completion("")
                return
            }
            let ref = Storage.storage().reference().child("profile_images/\(user.uid).jpg")
            ref.putData(data, metadata: nil) { _, error in
                if let error = error {
                    print("Upload failed: \(error.localizedDescription)")
                    completion("")
                    return
                }
                ref.downloadURL { url, _ in
                    completion(url?.absoluteString ?? "")
                }
            }
        }

        uploadPhotoIfNeeded { photoURL in
            var tags: [Tag] = []
            tags.append(Tag(text: region, color: "Region", sfSymbolName: "globe"))

            if playRanked && !rank.isEmpty {
                let matchedColor = availableRanks.contains(rank.lowercased()) ? rank.lowercased() : "gray"
                tags.append(Tag(text: rank, color: matchedColor, sfSymbolName: "trophy.fill"))
            }
            if playRanked && !mainAgent.isEmpty {
                tags.append(Tag(text: mainAgent, color: "mainAgent", sfSymbolName: "star.fill"))
            }

            let userData: [String: Any] = [
                "firstName": firstName,
                "lastName":  lastName,
                "region":    region,
                "photoURL":  photoURL,
                "tags":      tags.map { $0.dictionary },
                "profileComplete": true
            ]

            Firestore.firestore()
                .collection("users")
                .document(user.uid)
                .updateData(userData) { err in
                    isSaving = false
                    if let err = err {
                        print("Firestore update failed: \(err.localizedDescription)")
                    } else {
                        // Transition into the main app
                        authVM.finishOnboarding()
                    }
                }
        }
    }
}

#Preview {
    CompleteProfileView()
        .environmentObject(AuthViewModel())
}
