//
//  GitHubUser.swift
//  Hedvig_Hemuppgift
//
//  Created by Henrik Larsson on 2023-02-23.
//

import Foundation


struct GitHubUser: Decodable {
    
    let login: String?
    let avatar_url: String?
    
}

struct GitHubUserViewModel: Identifiable {
    var id = UUID()
    
    
    var user: GitHubUser
    
    var displayName: String {
        user.login?.capitalized ?? ""
    }
    
    var avatarUrl: String {
        user.avatar_url ?? ""
    }
    
}
