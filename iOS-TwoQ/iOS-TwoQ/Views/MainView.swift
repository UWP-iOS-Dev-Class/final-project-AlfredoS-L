//
//  MainView.swift
//  iOS-TwoQ
//
//  Created by Alfredo Sandoval-Luis on 4/2/25.
//

import SwiftUI

struct MainView: View {
    
    init() {
        UITabBar.appearance().backgroundColor = UIColor(named: "tabColor")
    }
    
    var body: some View {
        TabView {
            CardStackView()
                .tag(0)
                .tabItem {
                    Image(systemName: "binoculars.fill")
                }
            
            MatchesView()
                .tabItem {
                    Image(systemName: "tray.fill")
                }
                .tag(1)
                .tabItem { Image(systemName: "tray.fill") }
            
            UserProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                }
                .tag(2)
                .tabItem { Image(systemName: "person.fill") }
        }
        .tint(Color("tabItemColor"))
    }
}

#Preview {
    MainView()
        .environmentObject(AuthViewModel())
}
