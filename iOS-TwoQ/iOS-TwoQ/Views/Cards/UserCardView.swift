//
//  UserCardView.swift
//  iOS-TwoQ
//
//  Created by Alfredo Sandoval-Luis on 4/2/25.
//  !!!: look at previous code for replacements

import SwiftUI

struct UserCardView: View {
    
    let user: User = mockUsers[0]
    
    
    var body: some View {
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
                        prompt: "I geek out on",
                        response: "12 episode animes that have a cult following"
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
            Image(systemName: "photo") // TODO: Add user pictures
                .resizable()
                .scaledToFill()
                .clipped()
                .frame(width: 90, height: 90)
                .clipShape(Circle())
                .padding(.trailing, 10)
            
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

#Preview {
    UserCardView()
}
