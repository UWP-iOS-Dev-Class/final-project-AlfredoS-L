//
//  MainView.swift
//  iOS-TwoQ
//
//  Created by Alfredo Sandoval-Luis on 4/2/25.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var authVM: AuthViewModel

    init() {
        UITabBar.appearance().backgroundColor = UIColor(named: "tabColor")
    }

    var body: some View {
        TabView {
            CardStackView()
                .tabItem {
                    Image(systemName: "binoculars.fill")
                }
                .tag(0)

            MatchesView()
                .tabItem {
                    Image(systemName: "tray.fill")
                }
                .tag(1)

            UserProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                }
                .tag(2)
        }
        .tint(Color("tabItemColor"))
    }
}

#Preview {
    MainView()
        .environmentObject(AuthViewModel())
}
