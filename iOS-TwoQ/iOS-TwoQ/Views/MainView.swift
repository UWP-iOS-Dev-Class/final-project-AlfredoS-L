//
//  MainView.swift
//  iOS-TwoQ
//
//  Created by Alfredo Sandoval-Luis on 4/2/25.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            CardStackView()
                .tabItem { Image(systemName: "square.and.arrow.up") }
                .tag(0)
            
            MatchesView()
                .tabItem { Image(systemName: "person.3") }
                .tag(1)
            
            UserProfileView()
                .tabItem { Image(systemName: "person.crop.circle") }
                .tag(2)
        }
        .tint(Color.primary)
    }
}

#Preview {
    MainView()
}
