//
//  EditProfileView.swift
//  iOS-TwoQ
//
//  Created by Joseph Villalobos on 4/26/25.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import PhotosUI

// MARK: - EditProfileView
// This view allows the user to update their profile information (name, region, and profile picture).

struct EditProfileView: View {
    
    // MARK: - Environment
    @EnvironmentObject var authVM: AuthViewModel  // Access current authenticated user
    
    // MARK: - User Input Fields
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var region = ""
    
    // MARK: - Tracking Original Data
    @State private var originalFirstName = ""
    @State private var originalLastName = ""
    @State private var originalRegion = ""
    @State private var originalPhotoURL: URL?
    
    // MARK: - Image Selection
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    
    // MARK: - Save Operation State
    @State private var isSaving = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    @State private var showSuccess = false
    @State private var isSaveButtonDisabled = false
    @State private var showSaveConfirmation = false
    
    // MARK: - Body
    var body: some View {
        VStack {
            
            // MARK: - Profile Image Picker
            PhotosPicker(
                selection: $selectedItem,
                matching: .images,
                photoLibrary: .shared()
            ) {
                if let data = selectedImageData, let uiImage = UIImage(data: data) {
                    // Preview newly selected image
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                } else {
                    // Show stored image or default avatar
                    AsyncImage(url: authVM.user?.photoURL) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
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
            
            // MARK: - Editable Form
            Form {
                Section(header: Text("Profile Info")) {
                    TextField("First Name", text: $firstName)
                    TextField("Last Name", text: $lastName)
                    TextField("Region", text: $region)
                }
                .foregroundStyle(Color("textColor"))
                
                Section {
                    Button(action: {
                        showSaveConfirmation = true
                    }) {
                        if isSaving {
                            ProgressView("Saving...")
                        } else if showSuccess {
                            Label("Saved!", systemImage: "checkmark.circle.fill")
                                .foregroundStyle(Color.blue)
                        } else {
                            Text("Save Changes")
                                .foregroundStyle(hasChanges ? Color.blue : Color("textColor"))
                        }
                    }
                    .disabled(!hasChanges || isSaveButtonDisabled)
                    .opacity((hasChanges && !isSaveButtonDisabled) ? 1 : 0.5)
                }
            }
        }
        .background((Color("backgroundColor")))
        .onAppear(perform: loadUserData)
        
        // Alert after updating profile
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Update"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        
        // Confirm Save Action
        .alert("Confirm Save", isPresented: $showSaveConfirmation) {
            Button("Cancel", role: .cancel) {}
            Button("Save") {
                saveProfile()
            }
        } message: {
            Text("Please review and verify your changes before saving.")
        }
    }
    
    // MARK: - Computed Property: Check if changes exist
    var hasChanges: Bool {
        return firstName != originalFirstName ||
               lastName != originalLastName ||
               region != originalRegion ||
               selectedImageData != nil
    }
    
    // MARK: - Load Existing User Data
    func loadUserData() {
        guard let user = authVM.user else { return }
        
        firstName = user.displayName?.components(separatedBy: " ").first ?? ""
        lastName = user.displayName?.components(separatedBy: " ").dropFirst().joined(separator: " ") ?? ""
        originalFirstName = firstName
        originalLastName = lastName
        originalPhotoURL = user.photoURL
        
        let db = Firestore.firestore()
        db.collection("users").document(user.uid).getDocument { document, error in
            if let document = document, document.exists {
                let data = document.data()
                self.region = data?["region"] as? String ?? ""
                self.originalRegion = self.region
            } else {
                print("No region found or error: \(error?.localizedDescription ?? "unknown error")")
            }
        }
    }
    
    // MARK: - Save Profile Changes
    func saveProfile() {
        guard let user = authVM.user else { return }
        isSaving = true
        
        if let imageData = selectedImageData {
            uploadProfileImage(data: imageData, forUserID: user.uid) { url in
                self.updateAuthProfile(photoURL: url)
            }
        } else {
            updateAuthProfile(photoURL: nil)
        }
    }
    
    // MARK: - Update Firebase Auth & Firestore
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
            
            let db = Firestore.firestore()
            var userData: [String: Any] = [
                "firstName": self.firstName,
                "lastName": self.lastName,
                "region": self.region
            ]
            
            if let url = photoURL {
                userData["photoURL"] = url.absoluteString
            }
            
            db.collection("users").document(user.uid).updateData(userData) { err in
                if let err = err {
                    alertMessage = "Failed to save Firestore: \(err.localizedDescription)"
                    showAlert = true
                    isSaving = false
                } else {
                    withAnimation {
                        self.showSuccess = true
                    }
                    isSaving = false
                    isSaveButtonDisabled = true
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            self.showSuccess = false
                        }
                        isSaveButtonDisabled = false
                    }
                    
                    self.authVM.user = Auth.auth().currentUser
                }
            }
        }
    }
    
    // MARK: - Upload Profile Image to Firebase Storage
    private func uploadProfileImage(data: Data, forUserID uid: String, completion: @escaping (URL?) -> Void) {
        let storageRef = Storage.storage().reference().child("profile_images/\(uid).jpg")
        
        storageRef.putData(data, metadata: nil) { metadata, error in
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
