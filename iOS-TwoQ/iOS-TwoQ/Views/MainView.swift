//
//  MainView.swift
//  iOS-TwoQ
//
//  Created by Alfredo Sandoval-Luis on 4/2/25.
//

import SwiftUI

struct MainView: View {
    
    init() {
        UITabBar.appearance().backgroundColor = UIColor(named: "TabColor")
    }
    
    var body: some View {
        TabView {
            CardStackView()
                .tag(0)
                .tabItem { Image(systemName: "binoculars.fill") }
            
            MatchesView()
                .tag(1)
                .tabItem { Image(systemName: "tray.fill") }
            
            UserProfileView()
                .tag(2)
                .tabItem { Image(systemName: "person.fill") }
        }
        .tint(Color("TabItemColor"))
    }
}

#Preview {
  MainView()
    .environmentObject(AuthViewModel())
}
