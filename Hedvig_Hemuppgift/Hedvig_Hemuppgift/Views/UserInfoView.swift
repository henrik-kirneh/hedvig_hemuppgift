//
//  UserInfoView.swift
//  Hedvig_Hemuppgift
//
//  Created by Henrik Larsson on 2023-02-26.
//

import SwiftUI

struct UserInfoView: View {
    
    @Binding var user: GitHubUserViewModel?
    
    var body: some View {
        HStack {
            
            if let avatarUrl = user?.avatarUrl {
                AsyncImage(
                    url: URL(string: avatarUrl),
                    content: { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxHeight: 100)
                            .cornerRadius(4)
                            .shadow(radius: 2)
                    },
                    placeholder: {
                        ProgressView()
                    })
                
            }
            VStack {
                Text(user?.displayName ?? "")
                    .font(.system(.title, design: .rounded))
                
                Spacer()
            }
            Spacer()
            
        }.frame(height: 100)
    }
}

struct UserInfoView_Previews: PreviewProvider {
    static var previews: some View {
        UserInfoView(user: .constant(GitHubUserViewModel(user: GitHubUser(login: "Doh", avatar_url: ""))))
    }
}
