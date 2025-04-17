//
//  MockUser.swift
//  iOS-TwoQ
//
//  Created by Alfredo Sandoval-Luis on 4/9/25.
//

//let id: String
//var firstName: String
//var lastName: String
//var email: String

import Foundation

let mockUsers: [User] = [
    User(
        id: "1",
        firstName: "Alfredo",
        lastName: "Sandoval-Luis",
        email: "alfredosandoval@gmail.com",
        region: "north america",
        tags: [
            Tag(text: "Diamond", color: "diamond", sfSymbolName: "trophy.fill"),
            Tag(text: "Jett", color: "platinum", sfSymbolName: "star.fill"),
            Tag(text: "Midwest", color: "ascendant", sfSymbolName: "mappin")
        ]
    )
]
