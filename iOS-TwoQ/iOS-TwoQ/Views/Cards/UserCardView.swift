//
//  UserCardView.swift
//  iOS-TwoQ
//
//  Created by Alfredo Sandoval-Luis on 4/2/25.
//  !!!: look at previous code for replacements

import SwiftUI

struct UserCardView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    @ObservedObject var cardsViewModel: CardsViewModel
    
    var cardModel: CardModel
    
    var body: some View {
        let user = cardModel.user
        
        ZStack(alignment: .leading){
            ScrollView {
                // start of top view
                NamePictureView(user: user)
                // end of top view
                
                // start of tag bubble view
                HStack {
                    ForEach(user.tags) { tag in
                        TagBubbleView(
                            text: tag.text,
                            color: Color(tag.color),
                            sfSymbolName: tag.sfSymbolName
                        )
                    }
                    Spacer()
                }
                .padding(.bottom, 10)
                // end of tag bubble view
                
                // start of body view
                VStack(alignment: .leading, spacing: 12) {
                    PromptResponseBubbleView(
                        prompt: "THIS IS HARD CODED",
                        response: "will work on this next sprint, name and tags are being pulled from the database though 😁"
                    )
                    
                    UserSynopsisView(
                        texts: [
                            "Software Engineer",
                            "UW-Parkside",
                            "Golfer",
                            "Racine, Wisconsin",
                            "Cat Person"
                        ], sfSymbolStrings: [
                            "briefcase.fill",
                            "graduationcap.fill",
                            "figure.run",
                            "house.fill",
                            "pawprint.fill"
                        ]
                    )
                    
                    PromptResponseBubbleView(
                        prompt: "When my team starts losing I...",
                        response: "try to play safe to minimize mistakes"
                    )
                    // end of body view
                }
            }
            .padding()
            .scrollIndicators(.hidden)
        }
        .background(Color("backgroundColor"))
    }
}

struct NamePictureView: View {
    
    let user: User
    
    var body: some View {
        HStack {
            AsyncImage(url: user.photoURL) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 90, height: 90)
                        .clipShape(Circle())
                        .padding(.trailing, 10)
                default:
                    SkeletonView(.circle)
                        .frame(width: 90, height: 90)
                        .padding(.trailing, 10)
                }
            }
            
            VStack(alignment: .leading) {
                Text(user.firstName)
                    .font(.system(size: 28, weight: .bold))
                Text(user.lastName)
                    .font(.system(size: 28, weight: .bold))
            }
            
            Spacer()
        }
        .foregroundStyle(Color("textColor"))
        .padding(.bottom, 15)
    }
}

//#Preview {
//    UserCardView()
//}
