//
//  Constants.swift
//  iOS-TwoQ
//
//  Created by Alfredo Sandoval-Luis on 5/15/25.
//

import Foundation

enum Rank: String, CaseIterable, Codable {
  case iron
  case bronze
  case silver
  case gold
  case platinum
  case diamond
  case ascendant
  case immortal
  case radiant

  /// Numeric value in ascending order of skill
  var value: Int { Self.allCases.firstIndex(of: self)! }
}
