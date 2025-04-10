//
//  ContentView.swift
//  iOS-TwoQ
//
//  Created by Alfredo Sandoval-Luis on 4/2/25.
//

import SwiftUI

struct ContentView: View {
  @StateObject var authVM = AuthViewModel()
  
  var body: some View {
    // When authVM.isLoggedIn is true, show MainView.
    // Otherwise, show LoginView.
    Group {
      if authVM.isLoggedIn {
        MainView()
          .environmentObject(authVM)
      } else {
        LoginView()
          .environmentObject(authVM)
      }
    }
  }
}

#Preview {
  ContentView()
}
