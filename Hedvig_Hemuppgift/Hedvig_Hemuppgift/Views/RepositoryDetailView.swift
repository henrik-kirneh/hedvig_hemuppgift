//
//  RepositoryDetailView.swift
//  Hedvig_Hemuppgift
//
//  Created by Henrik Larsson on 2023-02-23.
//

import SwiftUI

struct RepositoryDetailView: View {
    
    @Binding var path: NavigationPath
    @Binding var user: GitHubUserViewModel?
    let repository: GitHubRepositoryViewModel?
    @State private var repositoryDetails: GitHubRepositoryDetailsViewModel?
    
    var body: some View {
        
        List {
            Section(header: Text("General.User")) {
                UserInfoView(user: $user)
            }
            
            Section(header: Text("General.Repository")) {
                Text(repository?.name ?? "")
            }
            
            Section(header: Text("General.Languages")) {
                ForEach(repositoryDetails?.languages ?? []) { language in
                    HStack {
                        Text(language.name)
                        Spacer()
                        Text("\(String(language.linesOfCode)) LOC")
                    }
                }
            }
            Section(header: Text("General.Contributors")) {
                ForEach(repositoryDetails?.contributors ?? []) { contributor in
                    Text(contributor.displayName)
                }
            }
        }
        .onAppear {
            Task {
                repositoryDetails = await getRepoDetails(repository: repository!)
            }
        }
    }
}


func getRepoDetails(repository: GitHubRepositoryViewModel) async -> GitHubRepositoryDetailsViewModel {
    
    var repoDetails = GitHubRepositoryDetailsViewModel()
    
    if let languages = try? await UrlSessionGitHubApiClient.getRepositoryLanguages(userName: repository.owner.displayName, repoName: repository.name) {
        
        repoDetails.languages = languages.map { language in
            return RepositoryLanguage(name: language.key, linesOfCode: language.value)
        }
    }
    
    if let contributors = try? await UrlSessionGitHubApiClient.getRepositoryContributors(userName: repository.owner.displayName, repoName: repository.name) {
        
        repoDetails.contributors = contributors.map { contributor in
            return GitHubUserViewModel(user: contributor)
        }
    }
    
    return repoDetails
}

struct RepositoryDetailView_Previews: PreviewProvider {
    
    static var previews: some View {
        RepositoryDetailView(path: .constant(NavigationPath()),
                             user: .constant(GitHubUserViewModel(user: GitHubUser(login: "Doh", avatar_url: nil))),
                             repository: GitHubRepositoryViewModel(repository: GitHubRepository(name: "Doh", owner: GitHubUser(login: "Doh", avatar_url: nil))))
    }
}
