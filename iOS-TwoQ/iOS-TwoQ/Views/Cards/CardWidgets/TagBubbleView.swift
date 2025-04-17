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
        .background(color.opacity(0.5))
        .cornerRadius(8)
    }
}

#Preview {
    TagBubbleView(text: "diamond", sfSymbolName: "trophy.fill", color: Color.purple)
}
