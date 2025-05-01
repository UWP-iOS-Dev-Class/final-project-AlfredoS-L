//
//  SkeletonView.swift
//  iOS-TwoQ
//
//  Created by Alfredo Sandoval-Luis on 4/30/25.
//

import SwiftUI

struct SkeletonView<S: Shape>: View {
    var shape: S
    var color: Color
    init(_ shape: S, _ color: Color = .gray.opacity(0.3)) {
        self.shape = shape
        self.color = color
    }
    @State private var isAnimating: Bool = false
    var body: some View {
        shape
            // skeleton effect
            .fill(color)
            .overlay {
                GeometryReader {
                    let size = $0.size
                    let skeletonWidth = size.width / 2
                    // limiting blur radius to 30
                    let blurRadius = max(skeletonWidth / 2, 30)
                    let blurDiameter = blurRadius * 2
                    // movement offsets
                    let minX = -(skeletonWidth + blurDiameter)
                    let maxX = size.width + skeletonWidth + blurDiameter
                    
                    Rectangle()
                        .fill(.gray)
                        .frame(width: skeletonWidth, height: size.height * 2)
                        .frame(height: size.height)
                        .blur(radius: blurRadius)
                        .rotationEffect(.init(degrees: rotation))
                        .blendMode(.softLight)
                    // moving from left to right indefinitely
                        .offset(x: isAnimating ? maxX : minX)
                }
            }
            .clipShape(shape)
            .compositingGroup()
            .onAppear {
                guard !isAnimating else { return }
                withAnimation(animation) {
                    isAnimating = true
                }
            }
            .onDisappear {
                // stopping animation
                isAnimating = false
            }
            .transaction {
                if $0.animation != animation {
                    $0.animation = .none
                }
            }
    }
    
    // customizable properties
    var rotation: Double {
        return 5
    }
    
    var animation: Animation {
        .easeInOut(duration: 1.5).repeatForever(autoreverses: false)
    }
}

#Preview {
    @Previewable
    @State var isLoading: Bool = false
    
    SkeletonView(.circle)
        .frame(width: 100, height: 100)
        .onTapGesture {
            isLoading.toggle()
        }
        .padding(.bottom, isLoading ? 15 : 0)
}
