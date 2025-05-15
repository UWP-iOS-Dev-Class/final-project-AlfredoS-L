//
//  CardsViewModel.swift
//  iOS-TwoQ
//
//  Created by Alfredo Sandoval-Luis on 4/22/25.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

@MainActor
class CardsViewModel: ObservableObject {
    @Published var cardModels = [CardModel]()
    @Published var ButtonSwipeAction: SwipeAction?
    
    private var matchService: MatchService?
    private let service: CardService
    
    func configure(with me: User) {
        matchService = MatchService(me: me)
      }

      // step 2: actually fetch
    func loadMatches(limit: Int = 10) async {
        guard let svc = matchService else { return }
        do {
            let matches = try await svc.fetchMatches(limit: limit)
            DispatchQueue.main.async {
                self.cardModels = matches
            }
        } catch {
            print("❌ Failed to load matches:", error)
        }
    }
    
    init(service: CardService) {
        self.service = service
        Task {
            await fetchCardModels()
        }
    }
    
    func fetchCardModels() async {
        do {
            self.cardModels = try await service.fetchCardModels()
        } catch {
            print("DEBUG: Failed to fetch cards with error: \(error)")
        }
    }
    
    func removeCard(_ card: CardModel){
        guard let index = cardModels.firstIndex(where: { $0.id == card.id }) else { return }
        cardModels.remove(at: index)
    }
    
    func handleSwipe(action: SwipeAction) {
        guard let topCard = cardModels.last else { return }

        switch action {
        case .like:
            addMatchToFirebase(for: topCard.user)
        case .reject:
            break
        }

        removeCard(topCard)
    }
    
    func addMatchToFirebase(for user: User) {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            print("No user ID found.")
            return
        }

        let db = Firestore.firestore()

        db.collection("users")
          .document(currentUserId)
          .collection("likedUsers")
          .document(user.id)
          .setData([
              "likedUserId": user.id,
              "timestamp": FieldValue.serverTimestamp()
          ]) { error in
              if let error = error {
                  print("Error saving liked user: \(error.localizedDescription)")
              } else {
                  print("✅ Saved like for user: \(user.id)")
              }
          }
    }

}
