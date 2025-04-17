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
                // end of top view
                
                // start of tag bubble view
                HStack {
                    TagBubbleView(
                        text: "diamond", sfSymbolName: "trophy.fill",
                        color: Color.purple
                    )
                    
                    TagBubbleView(
                        text: "jett", sfSymbolName: "star.fill",
                        color: Color.blue
                    )
                    
                    TagBubbleView(
                        text: "midwest", sfSymbolName: "mappin",
                        color: Color.green
                    )
                    
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
        .frame(width:UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/1.25)
        .cornerRadius(16)
        .padding(.horizontal)
        .background(Color("backgroundColor"))
        .cornerRadius(16)
//        .shadow(radius: 10)
    }
}

#Preview {
    UserCardView()
}
