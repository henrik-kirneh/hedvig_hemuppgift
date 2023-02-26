//
//  GitHubRepository.swift
//  Hedvig_Hemuppgift
//
//  Created by Henrik Larsson on 2023-02-23.
//

import Foundation


struct GitHubRepository: Decodable {
    let name: String
    let owner: GitHubUser
    
}

struct GitHubRepositoryViewModel: Identifiable {
    
    let id = UUID()
    
    let repository: GitHubRepository
    
    var name: String {
        repository.name
    }
    
    var owner: GitHubUserViewModel {
        GitHubUserViewModel(user: repository.owner)
    }
        
}

struct GitHubRepositoryDetailsViewModel: Identifiable {
    let id = UUID()
    
    var languages: [RepositoryLanguage]?
    var contributors: [GitHubUserViewModel]?
}

struct RepositoryLanguage: Identifiable {
    let id = UUID()
    
    let name: String
    let linesOfCode: Int
}
