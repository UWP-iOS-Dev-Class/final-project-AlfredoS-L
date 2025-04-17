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
                .foregroundStyle(Color("textColor"))
            Text(response)
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(Color("textColor"))
        }
        .padding(15)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color("bubblesColor"))
                .shadow(radius: 1, y: 4).opacity(0.45)
        )
        .multilineTextAlignment(.leading)
        .fixedSize(horizontal: false, vertical: true)
    }
}

#Preview {
    PromptResponseBubbleView(prompt: "I geek out on", response: "12 episode animes that have a cult following")
}
