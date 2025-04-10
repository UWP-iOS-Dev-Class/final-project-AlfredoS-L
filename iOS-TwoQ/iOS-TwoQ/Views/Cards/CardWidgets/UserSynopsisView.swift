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
                // Loop through texts with an index so we can add dividers between items
                ForEach(Array(texts.enumerated()), id: \.offset) { index, text in
                    Text(text)
                        .font(.system(size: 15, weight: .light))
                        .multilineTextAlignment(.leading)
                    
                    // Add a divider after every text except the last one
                    if index != texts.count - 1 {
                        Divider()
                            .frame(height: 1) // Explicit height to ensure rendering
                            .background(Color.black.opacity(0.3))  // Explicit color if needed
                            .padding(.horizontal, 8)
                    }
                }
            }
            .padding(12) // Internal padding around the content
            .frame(maxWidth: .infinity, alignment: .leading) // Fill the available horizontal space
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.secondary.opacity(0.9))
                    .shadow(radius: 2)
            )
            .foregroundColor(.black) // Set text color
            .fixedSize(horizontal: false, vertical: true) // Allow vertical expansion
        }
}

#Preview {
    UserSynopsisView(
        texts: [
            "This is the first line of the bbble.",
            "This is the second line",
            "Another informative line here.",
            "Yet one more line to illustrate the flexibility.",
            "Another informative line here.",
            "Another informative line here.",
            "Another informative line here.",
            "Another informative line here."
        ], sfSymbolStrings: [
            "arrow.up.circlepath",
            "trophy.fill"
        ]
    )
}
