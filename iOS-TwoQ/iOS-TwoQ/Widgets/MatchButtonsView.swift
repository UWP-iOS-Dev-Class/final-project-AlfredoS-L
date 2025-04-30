//
//  MatchButtonsView.swift
//  iOS-TwoQ
//
//  Created by Alfredo Sandoval-Luis on 4/30/25.
//

import SwiftUI

struct MatchButtonsView: View {
    @ObservedObject var cardsViewModel: CardsViewModel
    let buttonSize: CGFloat = 28
    
    var body: some View {
        HStack(spacing: 200)  {
            Button {
                cardsViewModel.ButtonSwipeAction = .reject
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: buttonSize, weight: .heavy))
                    .foregroundStyle(.red)

            }

            Button {
                cardsViewModel.ButtonSwipeAction = .like
            } label: {
                Image(systemName: "message.fill")
                    .font(.system(size: buttonSize, weight: .heavy))
                    .foregroundStyle(.green)
            }
        }
    }
}

#Preview {
    MatchButtonsView(cardsViewModel: CardsViewModel(service: CardService()))
}
