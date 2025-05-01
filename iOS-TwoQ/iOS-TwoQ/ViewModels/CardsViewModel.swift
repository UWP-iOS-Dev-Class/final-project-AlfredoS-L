//
//  CardsViewModel.swift
//  iOS-TwoQ
//
//  Created by Alfredo Sandoval-Luis on 4/22/25.
//

import Foundation

@MainActor
class CardsViewModel: ObservableObject {
    @Published var cardModels = [CardModel]()
    @Published var ButtonSwipeAction: SwipeAction?
    
    private let service: CardService
    
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
}
