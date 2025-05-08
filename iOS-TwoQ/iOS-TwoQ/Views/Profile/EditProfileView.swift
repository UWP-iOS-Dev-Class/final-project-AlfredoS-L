//
//  EditProfileView.swift
//  iOS-TwoQ
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import PhotosUI

// MARK: - EditProfileView
struct EditProfileView: View {
  
  @EnvironmentObject var authVM: AuthViewModel

  @State private var firstName = ""
  @State private var lastName = ""
  @State private var region = ""

  @State private var originalFirstName = ""
  @State private var originalLastName = ""
  @State private var originalRegion = ""
  @State private var originalPhotoURL: URL?

  @State private var firestorePhotoURL: URL? = nil
  @State private var selectedItem: PhotosPickerItem? = nil
  @State private var selectedImageData: Data? = nil

  @State private var isSaving = false
  @State private var showAlert = false
  @State private var alertMessage = ""

  @State private var showSuccess = false
  @State private var isSaveButtonDisabled = false
  @State private var showSaveConfirmation = false

  var body: some View {
    VStack {
      PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
        if let data = selectedImageData, let uiImage = UIImage(data: data) {
          Image(uiImage: uiImage)
            .resizable()
            .scaledToFill()
            .frame(width: 100, height: 100)
            .clipShape(Circle())
        } else {
          AsyncImage(url: authVM.user?.photoURL) { phase in
            switch phase {
            case .success(let image):
              image.resizable().scaledToFill()
            default:
              SkeletonView(.circle)
                   .frame(width: 100, height: 100)
            }
          }
          .frame(width: 100, height: 100)
          .clipShape(Circle())
        }
      }
      .onChange(of: selectedItem) {
        Task {
          if let data = try? await selectedItem?.loadTransferable(type: Data.self) {
            selectedImageData = data
          }
        }
      }
      .padding(.top, 20)

      Form {
        Section(header: Text("Profile Info")) {
          TextField("First Name", text: $firstName)
          TextField("Last Name", text: $lastName)
          TextField("Region", text: $region)
        }

        Section {
          Button(action: { showSaveConfirmation = true }) {
            if isSaving {
              ProgressView("Saving...")
            } else if showSuccess {
              Label("Saved!", systemImage: "checkmark.circle.fill")
                .foregroundColor(.green)
            } else {
              Text("Save Changes")
                .foregroundColor(hasChanges ? .blue : .primary)
            }
          }
          .disabled(!hasChanges || isSaveButtonDisabled)
          .opacity((hasChanges && !isSaveButtonDisabled) ? 1 : 0.5)
        }
      }
    }
    .navigationTitle("Edit Profile")
    .onAppear(perform: loadUserData)
    .alert(isPresented: $showAlert) {
      Alert(title: Text("Update"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
    }
    .alert("Confirm Save", isPresented: $showSaveConfirmation) {
      Button("Cancel", role: .cancel) {}
      Button("Save") {
        saveProfile()
      }
    } message: {
      Text("Please review and verify your changes before saving.")
    }
    .tint(.blue)
  }

  var hasChanges: Bool {
    firstName != originalFirstName ||
    lastName != originalLastName ||
    region != originalRegion ||
    selectedImageData != nil
  }

  func loadUserData() {
    guard let user = authVM.user else { return }

    firstName = user.displayName?.components(separatedBy: " ").first ?? ""
    lastName = user.displayName?.components(separatedBy: " ").dropFirst().joined(separator: " ") ?? ""
    originalFirstName = firstName
    originalLastName = lastName
    originalPhotoURL = user.photoURL

    Firestore.firestore().collection("users").document(user.uid).getDocument { document, error in
      if let document = document, document.exists {
        let data = document.data()
        self.firstName = data?["firstName"] as? String ?? ""
        self.lastName = data?["lastName"] as? String ?? ""
        self.region = data?["region"] as? String ?? ""
        self.firestorePhotoURL = URL(string: data?["photoURL"] as? String ?? "")
        self.originalFirstName = self.firstName
        self.originalLastName = self.lastName
        self.originalRegion = self.region
      } else {
        print("Failed to load user document: \(error?.localizedDescription ?? "Unknown error")")
      }
    }
  }

  func saveProfile() {
    guard let user = authVM.user else { return }
    isSaving = true

    if let imageData = selectedImageData {
      uploadProfileImage(data: imageData, forUserID: user.uid) { url in
        updateAuthProfile(photoURL: url)
      }
    } else {
      updateAuthProfile(photoURL: nil)
    }
  }

  private func updateAuthProfile(photoURL: URL?) {
    guard let user = authVM.user else { return }

    let changeRequest = user.createProfileChangeRequest()
    changeRequest.displayName = "\(firstName) \(lastName)"
    if let url = photoURL {
      changeRequest.photoURL = url
    }

    changeRequest.commitChanges { error in
      if let error = error {
        alertMessage = "Failed to update profile: \(error.localizedDescription)"
        showAlert = true
        isSaving = false
        return
      }

      var userData: [String: Any] = [
        "firstName": self.firstName,
        "lastName": self.lastName,
        "region": self.region
      ]

      if let url = photoURL {
        userData["photoURL"] = url.absoluteString
      }

      Firestore.firestore().collection("users").document(user.uid).updateData(userData) { err in
        if let err = err {
          alertMessage = "Failed to save Firestore: \(err.localizedDescription)"
          showAlert = true
          isSaving = false
        } else {
          withAnimation { self.showSuccess = true }
          isSaving = false
          isSaveButtonDisabled = true

          DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation { self.showSuccess = false }
            isSaveButtonDisabled = false
          }

          self.authVM.user = Auth.auth().currentUser
          self.firestorePhotoURL = photoURL
        }
      }
    }
  }

  private func uploadProfileImage(data: Data, forUserID uid: String, completion: @escaping (URL?) -> Void) {
    let storageRef = Storage.storage().reference().child("profile_images/\(uid).jpg")

    storageRef.putData(data, metadata: nil) { _, error in
      if let error = error {
        print("Failed to upload image: \(error.localizedDescription)")
        completion(nil)
        return
      }

      storageRef.downloadURL { url, error in
        if let error = error {
          print("Failed to fetch download URL: \(error.localizedDescription)")
          completion(nil)
          return
        }
        completion(url)
      }
    }
  }
}

// MARK: - Preview
#Preview {
  EditProfileView()
    .environmentObject(AuthViewModel())
}
