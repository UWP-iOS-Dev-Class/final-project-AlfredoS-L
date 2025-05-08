//
//  MatchesView.swift
//  iOS-TwoQ
//
//  Created by Alfredo Sandoval-Luis on 4/2/25.
//

import SwiftUI

struct MatchesView: View {
    @StateObject private var matchesViewModel = MatchesViewModel()

    var body: some View {
        NavigationView {
//            if matchesViewModel.likedUsers.isEmpty {
//                Text("No matches yet!")
//                    .foregroundStyle(Color.gray)
//            }
            List(matchesViewModel.likedUsers) { user in
                VStack(alignment: .leading) {
                    Text("\(user.firstName) \(user.lastName)")
                        .font(.headline)

                    HStack {
                        ForEach(user.tags) { tag in
                            Text(tag.text)
                                .padding(6)
                                .background(Color(tag.color))
                                .cornerRadius(8)
                        }
                    }
                }
                .padding(.vertical, 8)
            }
            .onAppear {
                // eventually we will want to cache these, pull to refresh, or
                // add more info to likedUsers subcollection to avoid 2 reads
                matchesViewModel.fetchLikedUsers()
            }
        }
    }
}


#Preview {
    MatchesView()
}
