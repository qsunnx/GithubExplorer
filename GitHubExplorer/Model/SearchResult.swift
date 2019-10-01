//
//  SearchResult.swift
//  GitHubExplorer
//
//  Created by Кирилл Юдин on 18/04/2019.
//  Copyright © 2019 Кирилл Юдин. All rights reserved.
//

import Foundation

struct SearchResult: Codable {
    let totalCount: Int?
    let incomplete_results: Bool?
    let items: [RepositorySearchItem]?    
    
    private enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case incomplete_results
        case items
    }
}

struct RepositorySearchItem: Codable {
    let id: Double?
    let name: String?
    let full_name: String?
    let htmlURL: URL?
    let url: URL?
    let description: String?
    let owner: RepositoryOwner?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case full_name
        case htmlURL = "html_url"
        case url
        case description
        case owner
    }
}

struct RepositoryOwner: Codable {
    let name: String?
    let id: Double?
    let avatarURL: URL?
    let url: URL?
    
    private enum CodingKeys: String, CodingKey {
        case name = "login"
        case id
        case avatarURL = "avatar_url"
        case url
    }
}
