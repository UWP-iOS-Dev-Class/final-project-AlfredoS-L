//
//  UserCardView.swift
//  iOS-TwoQ
//
//  Created by Alfredo Sandoval-Luis on 4/2/25.
//  !!!: look at previous code for replacements

import SwiftUI

struct UserCardView: View {
    var body: some View {
//        ZStack(alignment: .leading){
        VStack(alignment: .leading) {
            ScrollView {
                HStack {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFill()
                        .clipped()
                        .frame(width: 90, height: 90)
                        .clipShape(Circle())
                    
                    Spacer()
                    
                    Text("Alfredo Sandoval-Luis")
                        .font(.system(size: 24, weight: .bold))
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    // TODO: Turn these into a view for reusability, passing in image name and color
                    HStack {
                        HStack {
                            Image(systemName: "trophy.fill")
                                .resizable()
                                .frame(width: 15, height: 15)
                            Text("diamond")
                                .font(.system(size: 14))
                        }
                        .padding(.vertical, 3)
                        .padding(.horizontal, 7)
                        .background(Color.purple.opacity(0.5))
                        .cornerRadius(8)
                        
                        HStack {
                            Image(systemName: "star.fill")
                                .resizable()
                                .frame(width: 15, height: 15)
                            Text("Jett")
                                .font(.system(size: 14))
                        }
                        .padding(.vertical, 3)
                        .padding(.horizontal, 7)
                        .background(Color.blue.opacity(0.5))
                        .cornerRadius(8)
                        
                        HStack {
                            Image(systemName: "mappin")
                                .resizable()
                                .frame(width: 7, height: 15)
                            Text("midwest")
                                .font(.system(size: 14))
                        }
                        .padding(.vertical, 3)
                        .padding(.horizontal, 7)
                        .background(Color.green.opacity(0.5))
                        .cornerRadius(8)
                        
                        Spacer()
                    }
                }
            }
            .padding()
        }
//        }
        .frame(width:UIScreen.main.bounds.width-10, height: UIScreen.main.bounds.height/1.45)
        .cornerRadius(16)
        .padding(.horizontal)
        .background(Color.gray.opacity(0.5))
        .cornerRadius(16)
        .shadow(radius: 10)
    }
}

#Preview {
    UserCardView()
}
