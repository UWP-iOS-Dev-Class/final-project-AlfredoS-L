//
//  PromptResponseBubbleView.swift
//  iOS-TwoQ
//
//  Created by Alfredo Sandoval-Luis on 4/9/25.
//

import SwiftUI

struct PromptResponseBubbleView: View {
    var prompt: String
    var response: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(prompt)
                .font(.system(size: 15, weight: .light))
                .padding(.bottom, 5)
            Text(response)
                .font(.system(size: 20, weight: .medium))
        }
        .padding(15) // Space between the text and the bubble's edge
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.secondary.opacity(0.9)) // Background color with opacity
                .shadow(radius: 2) // Optional: adds a subtle shadow
        )
        .foregroundColor(.black) // Text color
        .multilineTextAlignment(.leading)
        .fixedSize(horizontal: false, vertical: true) // Allow the bubble to grow vertically
    }
}

#Preview {
    PromptResponseBubbleView(prompt: "I geek out on", response: "12 episode animes that have a cult following")
}
