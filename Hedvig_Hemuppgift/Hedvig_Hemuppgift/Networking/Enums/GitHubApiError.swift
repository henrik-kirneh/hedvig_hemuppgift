//
//  GitHubApiError.swift
//  Hedvig_Hemuppgift
//
//  Created by Henrik Larsson on 2023-02-26.
//

import Foundation

enum GitHubApiError : Error {
    case notFound
    case invalidURL
    case other
}
