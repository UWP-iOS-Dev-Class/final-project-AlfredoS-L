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
    // supplementary user information
    var tags: [Tag] = []
    
    var dictionary: [String:Any] {
        return [
            "firstName": firstName,
            "lastName":  lastName,
            "email":     email,
            "region":    region,
            // ↳ Store tags as an array of dictionaries:
            "tags":      tags.map { $0.dictionary }
        ]
    }
    // game specific user information
}
