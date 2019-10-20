//
//  RepositorySearchItem.swift
//  GitHubExplorer
//
//  Created by Кирилл Юдин on 19.10.2019.
//  Copyright © 2019 Кирилл Юдин. All rights reserved.
//

import Foundation

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
