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
                    ZStack {
                        ForEach(cardsViewModel.cardModels) { card in
                            Text("Something should be here")
                        }
                    }
                    if cardsViewModel.cardModels.isEmpty {
                        UserCardView()
                    }
                }
            }
        }
    }
}

#Preview {
    CardStackView()
}
