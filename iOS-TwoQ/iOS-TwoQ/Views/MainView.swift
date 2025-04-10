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
        .tabItem { Image(systemName: "binoculars.fill") }
        .tag(0)
      
      MatchesView()
        .tabItem { Image(systemName: "tray.fill") }
        .tag(1)
      
      UserProfileView()
        .tabItem { Image(systemName: "person.fill") }
        .tag(2)
    }
    .tint(Color.primary)
  }
}

#Preview {
  MainView()
    .environmentObject(AuthViewModel())
}
