//
//  User.swift
//  iOS-TwoQ
//
//  Created by Alfredo Sandoval-Luis on 4/2/25.
//

import Foundation

// MARK: - User Model
// This struct represents a User in your app and matches how you store user data in Firestore.

struct User: Identifiable, Codable, Hashable {
    
    // MARK: - Essential User Information
    let id: String           // Unique user ID (matches Firebase UID)
    var firstName: String    // User's first name
    var lastName: String     // User's last name
    var email: String        // User's email address
    var region: String       // User's selected region/location
    var photoURL: String     // URL string to the user's profile picture
    
    // MARK: - Supplementary User Information
    var tags: [Tag] = []     // List of user's selected tags (interests, preferences, etc.)
    
    // MARK: - (Placeholder)
    // Future fields for game-specific or app-specific user data can be added here.
}
