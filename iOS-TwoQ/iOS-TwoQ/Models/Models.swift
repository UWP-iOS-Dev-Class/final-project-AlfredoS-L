//
//  Models.swift
//  iOS-TwoQ
//
//  Created by Alfredo Sandoval-Luis on 4/16/25.
//

import Foundation

// MARK: MODELS
struct Tag: Identifiable, Codable, Hashable {
    var id: String = UUID().uuidString
    let text: String
    let color: String
    var sfSymbolName: String//? = nil
    
    var dictionary: [String:Any] {
        return [
            "id":          id,
            "text":        text,
            "color":       color,
            "sfSymbolName": sfSymbolName
        ]
    }
}

struct CardModel {
    let user: User
}

// MARK: EXTENSIONS

extension CardModel: Identifiable, Hashable {
    var id: String { user.id }
}

// MARK: ENUMS
enum SwipeAction {
    case reject
    case like
}
