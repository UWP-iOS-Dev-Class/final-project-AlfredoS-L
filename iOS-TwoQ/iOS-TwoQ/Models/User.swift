//
//  User.swift
//  iOS-TwoQ
//
//  Created by Alfredo Sandoval-Luis on 4/2/25.
//

import Foundation

struct User: Identifiable, Codable, Hashable {  
    // essential user information
    let id: String
    var firstName: String
    var lastName: String
    var email: String
    var region: String
    var photoURL: URL?
    var profileComplete: Bool = true // temp
    // supplementary user information
    var tags: [Tag] = []
    
    var dictionary: [String:Any] {
        return [
            "firstName": firstName,
            "lastName":  lastName,
            "email":     email,
            "region":    region,
            "photoURL":        photoURL?.absoluteString as Any,
            "profileComplete": profileComplete,
            // ↳ Store tags as an array of dictionaries:
            "tags":      tags.map { $0.dictionary }
        ]
    }
    // game specific user information
}

extension User {
  /// Finds the rank‑tag, then converts to our `Rank` enum
  var rank: Rank? {
    tags
      .first { $0.color != "Region" && $0.color != "mainAgent" }
      .flatMap { Rank(rawValue: $0.text) }
  }
}

