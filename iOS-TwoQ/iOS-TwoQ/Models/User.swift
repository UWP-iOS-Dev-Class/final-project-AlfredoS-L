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
    // supplementary user information
    var tags: [Tag] = []
    // game specific user information
}
