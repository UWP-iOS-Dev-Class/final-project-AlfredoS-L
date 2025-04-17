//
//  Models.swift
//  iOS-TwoQ
//
//  Created by Alfredo Sandoval-Luis on 4/16/25.
//

import Foundation

struct Tag: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    let text: String
    let color: String
    var sfSymbolName: String//? = nil
}
