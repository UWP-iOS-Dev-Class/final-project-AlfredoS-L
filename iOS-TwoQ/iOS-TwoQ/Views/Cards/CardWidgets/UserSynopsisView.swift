//
//  UserSynopsisView.swift
//  iOS-TwoQ
//
//  Created by Alfredo Sandoval-Luis on 4/9/25.
//

import SwiftUI

struct UserSynopsisView: View {
    var texts: [String]
    var sfSymbolStrings: [String]

        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                // loop through texts with an index so we can add dividers between items
                ForEach(Array(texts.enumerated()), id: \.offset) { index, text in
                    HStack {
                        Image(systemName: sfSymbolStrings[index])
                            .font(.system(size: 15))
                        Text(text)
                            .font(.system(size: 15, weight: .light))
                            .multilineTextAlignment(.leading)
                    }
                    .foregroundStyle(Color("textColor"))
                    
                    // a divider after every text except the last one
                    if index != texts.count - 1 {
                        Divider()
                            .frame(height: 1) // explicit height to ensure rendering
                            .background(Color("textColor"))  // explicit color if needed
                            .padding(.horizontal, 8)
                    }
                }
            }
            .padding(15)
//            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color("bubblesColor"))
                    .shadow(radius: 1, y: 4).opacity(0.45)
            )
            .fixedSize(horizontal: false, vertical: true)
        }
}

#Preview {
    UserSynopsisView(
        texts: [
            "This is the first line of the bbble.",
            "This is the second line",
            "Another informative line here."
        ], sfSymbolStrings: [
            "mappin",
            "trophy.fill",
            "trophy.fill"
        ]
    )
}
