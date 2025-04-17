//
//  UserProfileView.swift
//  iOS-TwoQ
//
//  Created by Alfredo Sandoval-Luis on 4/2/25.
//

import SwiftUI

struct UserProfileView: View {
  @EnvironmentObject var authVM: AuthViewModel
  
  var body: some View {
    VStack {
      Text("Where Users see their profile and settings")
      
      Button("Sign Out") {
        authVM.signOut()
      }
      .bold()
      .foregroundColor(.white)
      .padding()
      .frame(maxWidth: .infinity)
      .background(Color.orange)
      .cornerRadius(8)
      .padding(.horizontal, 80)
      .padding(.top, 20)
    }
  }
}

#Preview {
  UserProfileView()
    .environmentObject(AuthViewModel())
}
