//
//  CardService.swift
//  iOS-TwoQ
//
//  Created by Alfredo Sandoval-Luis on 4/22/25.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestoreCombineSwift

struct CardService {

    func fetchCardModels() async throws -> [CardModel] {
      // 1) Throw on any Firestore error
      let snapshot = try await Firestore.firestore()
                                    .collection("users")
                                    .getDocuments()

      // 2) Decode each document (and log failures)
      let users: [User] = snapshot.documents.compactMap { doc in
        do {
          return try doc.data(as: User.self)
        } catch {
          print("---!Decoding failed for \(doc.documentID): \(error)!---")
          return nil
        }
      }

      // 3) Take up to 10 users
      let firstTen = Array(users.prefix(10))

      // 4) Convert to CardModel
      return firstTen.map { CardModel(user: $0) }
    }
}
