//
//  MatchService.swift
//  iOS-TwoQ
//
//  Created by Alfredo Sandoval-Luis on 5/15/25.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestoreCombineSwift

struct MatchService {
  let db = Firestore.firestore()
  let me: User

  func fetchMatches(limit: Int = 10) async throws -> [CardModel] {
    // 1. Only your region
    let snapshot = try await db
      .collection("users")
      .whereField("region", isEqualTo: me.region)
      .getDocuments()

    let candidates = snapshot.documents
      .compactMap { try? $0.data(as: User.self) }
      .filter { $0.id != me.id }

    // 2. Filter to ±1 rank
    let myRankValue = me.rank?.value ?? 0
    let nearby = candidates.filter {
      guard let r = $0.rank else { return false }
      return abs(r.value - myRankValue) <= 1
    }

    // 3. Score by “different agent” bonus
    let myAgent = me.tags.first { $0.color == "mainAgent" }?.text
    let scored: [(User, Double)] = nearby.map { user in
      // base score: everyone in region & within rank gets 100
      let base = 100.0

      // small bonus if they play a different agent
      let userAgent = user.tags.first { $0.color == "mainAgent" }?.text
      let agentScore = (userAgent != myAgent) ? 5.0 : 0.0

      return (user, base + agentScore)
    }

    // 4. Sort & wrap
    return scored
      .sorted { $0.1 > $1.1 }
      .prefix(limit)
      .map { CardModel(user: $0.0) }
  }
}

