//
//  TagBubbleView.swift
//  iOS-TwoQ
//
//  Created by Alfredo Sandoval-Luis on 4/9/25.
//

import SwiftUI

struct TagBubbleView: View {
    
    @Environment(\.colorScheme) private var colorScheme
    
    let text: String
    let color: Color
    let sfSymbolName: String
    
    var body: some View {
        HStack {
            Image(systemName: sfSymbolName)
            
            Text(text)
                .padding(.trailing, 3)
        }
//        .foregroundStyle(Color("textColor"))
        .foregroundStyle(Color.white)
        .font(.system(size: 14))
        .padding(.vertical, 3)
        .padding(.horizontal, 7)
        .background(
          color
            .opacity(colorScheme == .light ? 0.85 : 0.6)
        )
        .cornerRadius(8)
    }
}

#Preview {
    TagBubbleView(text: "diamond", color: Color("diamond"), sfSymbolName: "trophy.fill")
}
