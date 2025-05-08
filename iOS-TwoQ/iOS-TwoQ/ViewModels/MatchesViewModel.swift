//
//  MatchesViewModel.swift
//  iOS-TwoQ
//
//  Created by Alfredo Sandoval-Luis on 5/5/25.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class MatchesViewModel: ObservableObject {
    @Published var likedUsers: [User] = []

    func fetchLikedUsers() {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            print("No signed-in user.")
            return
        }

        let db = Firestore.firestore()
        let likedUsersRef = db.collection("users")
            .document(currentUserId)
            .collection("likedUsers")

        likedUsersRef.getDocuments { snapshot, error in
            if let error = error {
                print("Failed to fetch liked users: \(error)")
                return
            }

            let likedUserIds = snapshot?.documents.map { $0.documentID } ?? []

            // Fetch actual user data for each liked user
            let usersRef = db.collection("users")
            var fetchedUsers: [User] = []

            let group = DispatchGroup()

            for id in likedUserIds {
                group.enter()
                usersRef.document(id).getDocument { docSnapshot, error in
                    defer { group.leave() }

                    if let doc = docSnapshot, doc.exists {
                        do {
                            let user = try doc.data(as: User.self)
                            fetchedUsers.append(user)
                        } catch {
                            print("Error decoding user \(id): \(error)")
                        }
                    }
                }
            }

            group.notify(queue: .main) {
                self.likedUsers = fetchedUsers
            }
        }
    }
}

