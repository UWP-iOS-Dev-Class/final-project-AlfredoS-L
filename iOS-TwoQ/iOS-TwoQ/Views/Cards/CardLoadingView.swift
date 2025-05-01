//
//  CardLoadingView.swift
//  iOS-TwoQ
//
//  Created by Alfredo Sandoval-Luis on 4/30/25.
//

import SwiftUI

struct CardLoadingView: View {
    let cornerRadius: CGFloat = 5
    let bubbleHeight: CGFloat = 20
    let bubbleWidth: CGFloat = 290
    
    var body: some View {
        ZStack {
            ScrollView {
                NamePictureLoadingView(cornerRadius: cornerRadius)
                
                BubbleLoadingView(cornerRadius: cornerRadius, bubbleHeight: bubbleHeight, bubbleWidth: bubbleWidth)
                
                BodyLoadingView(cornerRadius: cornerRadius)
            }
            .padding()
            .scrollIndicators(.hidden)
        }
        .background(Color("backgroundColor"))
    }
}

struct NamePictureLoadingView: View {
    let cornerRadius: CGFloat
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                SkeletonView(.circle)
                    .frame(width: 90, height: 90)
                    .padding(.trailing, 10)
                
                VStack(alignment: .leading) {
                    SkeletonView(.rect(cornerRadius: cornerRadius))
                        .frame(width: 170, height: 28)
                    SkeletonView(.rect(cornerRadius: 5))
                        .frame(width: 230, height: 28)

                }
                Spacer()
            }
            .padding(.bottom, 15)
        }
    }
}

struct BubbleLoadingView: View {
    let cornerRadius: CGFloat
    let bubbleHeight: CGFloat
    let bubbleWidth: CGFloat
    
    var body: some View {
        HStack {
            SkeletonView(.rect(cornerRadius: cornerRadius))
                .frame(width: bubbleWidth, height: bubbleHeight)
                .padding(.horizontal, 3)
                .padding(.vertical, 3)
            Spacer()
        }
        .padding(.bottom, 10)
    }
}

struct BodyLoadingView: View {
    let cornerRadius: CGFloat
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Rectangle()
                .foregroundStyle(.clear)
                .overlay {
                    SkeletonView(.rect)
                }
                .frame(height: 135)
                .cornerRadius(cornerRadius)
            
            Rectangle()
                .foregroundStyle(.clear)
                .overlay {
                    SkeletonView(.rect)
                }
                .frame(height: 265)
                .cornerRadius(cornerRadius)
            
            Rectangle()
                .foregroundStyle(.clear)
                .overlay {
                    SkeletonView(.rect)
                }
                .frame(height: 175)
                .cornerRadius(cornerRadius)
        }
    }
}

#Preview {
    CardLoadingView()
}
