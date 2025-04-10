//
//  TagBubbleView.swift
//  iOS-TwoQ
//
//  Created by Alfredo Sandoval-Luis on 4/9/25.
//

import SwiftUI

struct TagBubbleView: View {
    
    let text: String
    let sfSymbolName: String
    let color: Color
    let width: CGFloat
    let height: CGFloat
    
    var body: some View {
        HStack {
            Image(systemName: sfSymbolName)
                .resizable()
                .frame(width: width, height: height)
            Text(text)
                .font(.system(size: 14))
        }
        .padding(.vertical, 3)
        .padding(.horizontal, 7)
        .background(color.opacity(0.5))
        .cornerRadius(8)
    }
}

#Preview {
    TagBubbleView(text: "diamond", sfSymbolName: "trophy.fill", color: Color.purple, width: 15, height: 15)
}
