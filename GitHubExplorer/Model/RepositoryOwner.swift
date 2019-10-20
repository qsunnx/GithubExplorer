//
//  RepositoryOwner.swift
//  GitHubExplorer
//
//  Created by Кирилл Юдин on 19.10.2019.
//  Copyright © 2019 Кирилл Юдин. All rights reserved.
//

import Foundation

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
