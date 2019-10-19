//
//  User.swift
//  GitHubExplorer
//
//  Created by Кирилл Юдин on 04/10/2019.
//  Copyright © 2019 Кирилл Юдин. All rights reserved.
//

import Foundation


struct User: Codable {
    let login: String
    let avatar_url: String?
    
    private enum CodingKeys: String, CodingKey {
        case login
        case avatar_url
    }
}
