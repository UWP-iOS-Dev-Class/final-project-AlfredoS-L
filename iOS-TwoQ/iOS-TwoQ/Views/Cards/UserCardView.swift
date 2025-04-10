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
                    Image(systemName: "photo")
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
                // end of top view
                
                // start of tag bubble view
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        TagBubbleView(
                            text: "diamond", sfSymbolName: "trophy.fill",
                            color: Color.purple, width: 15, height: 15
                        )
                        
                        TagBubbleView(
                            text: "jett", sfSymbolName: "star.fill",
                            color: Color.blue, width: 15, height: 15
                        )
                        
                        TagBubbleView(
                            text: "midwest", sfSymbolName: "mappin",
                            color: Color.green, width: 7, height: 15
                        )
                        
                        Spacer()
                    }
                    .padding(.bottom, 8)
                    // end of tag bubble view
                    
                    // start of body view
                    PromptResponseBubbleView(prompt: "I geek out on", response: "12 episode animes that have a cult following")
                    UserSynopsisView(
                        texts: [
                            "This is the first line of the bbble.",
                            "This is the second line",
                            "Another line here.",
                            "Another informative line here.",
                            "Another informative line here.",
                            "Another informative line here.",
                            "Another informative line here."
                        ], sfSymbolStrings: [
                            "arrow.up.circlepath",
                            "trophy.fill"
                        ]
                    )
                    // end of body view
                }
            }
            .padding()
            .scrollIndicators(.hidden)
        }
        .frame(width:UIScreen.main.bounds.width-10, height: UIScreen.main.bounds.height/1.25)
        .cornerRadius(16)
        .padding(.horizontal)
        .background(Color.gray.opacity(0.5))
        .cornerRadius(16)
        .shadow(radius: 10)
    }
}

#Preview {
    UserCardView()
}
