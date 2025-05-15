//
//  CardStackView.swift
//  iOS-TwoQ
//
//  Created by Alfredo Sandoval-Luis on 4/2/25.
//
//  

import SwiftUI

struct CardStackView: View {
    @StateObject var cardsViewModel = CardsViewModel(service: CardService())
    
    @EnvironmentObject var authViewModel: AuthViewModel
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    ZStack(alignment: .bottom) {
                        ForEach(cardsViewModel.cardModels) { cardModel in
                            UserCardView(cardsViewModel: cardsViewModel, cardModel: cardModel)
                        }
                        if !cardsViewModel.cardModels.isEmpty {
                            MatchButtonsView(cardsViewModel: cardsViewModel)
                                .padding(.bottom, 20)
                        }
                    }
                    if cardsViewModel.cardModels.isEmpty {
                        CardLoadingView()
                    }
                }
                .onAppear {
                  guard let me = authViewModel.currentUser else { return }
                  // tell your view model who “me” is
                  cardsViewModel.configure(with: me)
                }
                .task {
                  // then fetch matches once “me” is set
                  await cardsViewModel.loadMatches()
                }
            }
        }
    }
}

#Preview {
    CardStackView()
}
