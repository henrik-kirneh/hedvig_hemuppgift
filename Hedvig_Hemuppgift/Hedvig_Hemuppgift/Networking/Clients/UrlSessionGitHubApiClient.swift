//
//  GitHubApi.swift
//  Hedvig_Hemuppgift
//
//  Created by Henrik Larsson on 2023-02-23.
//

import Foundation


enum UrlSessionGitHubApiClient: GitHubApiClient {
    static let base = URL(string: "https://api.github.com")!
}


extension UrlSessionGitHubApiClient {
    
    static func getUserRepositories(userName: String) async throws -> [GitHubRepository] {

        guard let url = URL(string: "\(base)/users/\(userName)/repos") else {
            throw GitHubApiError.invalidURL
        }

        let (data, _) = try await URLSession.shared.data(from: url)

        do {
            let result = try JSONDecoder().decode([GitHubRepository].self, from: data)
            
            return result
        } catch {
            throw GitHubApiError.notFound
        }
        
    }
    
    static func getOrganisationRepositories(orgName: String) async throws -> [GitHubRepository] {

        guard let url = URL(string: "\(base)/orgs/\(orgName)/repos") else {
            throw GitHubApiError.invalidURL
        }

        let (data, _) = try await URLSession.shared.data(from: url)

        do {
            let result = try JSONDecoder().decode([GitHubRepository].self, from: data)
            
            return result
        } catch {
            throw GitHubApiError.notFound
        }
        
    }
       
    static func getRepositoryLanguages(userName: String, repoName: String) async throws -> [String: Int] {

        guard let url = URL(string: "\(base)/repos/\(userName)/\(repoName)/languages") else {
            throw GitHubApiError.invalidURL
        }

        let (data, _) = try await URLSession.shared.data(from: url)
            
        do {
            let result = try JSONDecoder().decode([String: Int].self, from: data)
            return result
        } catch {
            throw GitHubApiError.notFound
        }
    }
    
    static func getRepositoryContributors(userName: String, repoName: String) async throws -> [GitHubUser] {

        guard let url = URL(string: "\(base)/repos/\(userName)/\(repoName)/contributors") else {
            throw GitHubApiError.invalidURL
        }

        let (data, _) = try await URLSession.shared.data(from: url)

        do {
            let result = try JSONDecoder().decode([GitHubUser].self, from: data)
            return result
        } catch {
            throw GitHubApiError.notFound
        }
    }
    

}






