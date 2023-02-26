//
//  SearchView.swift
//  Hedvig_Hemuppgift
//
//  Created by Henrik Larsson on 2023-02-23.
//

import SwiftUI

enum SearchType {
    case User
    case Organisation
}

struct SearchView: View {
    
    @State private var path = NavigationPath()
    
    @State private var userRepoSearchResults: [GitHubRepositoryViewModel]?
    @State private var currentUser: GitHubUserViewModel?
    @State private var searchFieldInput: String = ""
    
    @State private var apiError: GitHubApiError?
    
    @State private var selectedSearchType: SearchType = .User
    
    var selectionBinding: Binding<SearchType> {
        Binding(
            get: {
                $selectedSearchType.wrappedValue
            },
            set: { (newValue, tnx) in
                
                $selectedSearchType.transaction(tnx).wrappedValue = newValue
                
                Task {
                    userRepoSearchResults = await searchUserRepositories(name: searchFieldInput, searchType: newValue)
                    
                    if let user = userRepoSearchResults?.first?.owner {
                        currentUser = user
                    }
                }
            }
        )
    }
    
    var body: some View {
        VStack {
            Picker("", selection: selectionBinding) {
                Text("General.User").tag(SearchType.User)
                Text("General.Organisation").tag(SearchType.Organisation)
            }
            .pickerStyle(.segmented)
            .accessibilityLabel(AccessibilityLabels.SearchTypeSelector.rawValue)
            
            List {
                if (userRepoSearchResults?.count ?? 0 > 0) {
                    
                    Section(header: Text("General.User")) {
                        UserInfoView(user: $currentUser)
                    }
                    
                    Section(header: Text("General.Repositories")) {
                        ForEach(userRepoSearchResults ?? []) { repo in
                            NavigationLink(destination: {
                                RepositoryDetailView(path: $path, user: $currentUser, repository: repo)
                            }) {
                                Text(repo.name)
                            }
                        }
                    }
                }
                else if apiError != nil {
                    switch apiError {
                    case .notFound:
                        selectedSearchType == .User ?
                        Text("InfoMessage.UserNotFound")
                        : Text("InfoMessage.OrganisationNotFound")
                    default:
                        Text("InfoMessage.SomethingWentWrong")
                    }
                    
                } else if userRepoSearchResults?.count == 0 {
                    Text("InfoMessage.NoUserRepos")
                }
            }
            .listStyle(.insetGrouped)
            .searchable(text: $searchFieldInput, prompt: "SearchView.SearchFieldPrompt")
            .onSubmit(of: .search) {
                
                Task {
                    userRepoSearchResults = await searchUserRepositories(name: searchFieldInput, searchType: selectedSearchType)
                    
                    if let user = userRepoSearchResults?.first?.owner {
                        currentUser = user
                    }
                }
            }
            .autocorrectionDisabled()
            .navigationTitle("SearchView.NavigationTitle")
            .accessibilityLabel(AccessibilityLabels.UserSearchField.rawValue)
        }
    }
    
    
    func searchUserRepositories(name: String, searchType: SearchType) async -> [GitHubRepositoryViewModel]? {
        
        let nameTrimmed = name.trimmingCharacters(in: .whitespaces).lowercased()
        
        
        do {
            var repos: [GitHubRepository] = []
            
            switch searchType {
            case .User:
                repos = try await UrlSessionGitHubApiClient.getUserRepositories(userName: nameTrimmed)
            case .Organisation:
                repos = try await UrlSessionGitHubApiClient.getOrganisationRepositories(orgName:  nameTrimmed)
            }
            
            apiError = nil
            
            let vms = repos.map { GitHubRepositoryViewModel(repository: $0) }
            
            return vms
            
            
        } catch GitHubApiError.notFound {
            apiError = GitHubApiError.notFound
        } catch {
            apiError = GitHubApiError.other
        }
        return nil
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
