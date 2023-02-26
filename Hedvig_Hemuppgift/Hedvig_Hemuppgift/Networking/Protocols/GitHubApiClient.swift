//
//  GitHubApiClient.swift
//  Hedvig_Hemuppgift
//
//  Created by Henrik Larsson on 2023-02-26.
//

import Foundation


protocol GitHubApiClient {
    
    static func getUserRepositories(userName: String) async throws -> [GitHubRepository]
    
    static func getRepositoryLanguages(userName: String, repoName: String) async throws -> [String: Int]
    
    static func getRepositoryContributors(userName: String, repoName: String) async throws -> [GitHubUser]
}
