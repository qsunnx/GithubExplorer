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
