//
//  SearchResultTableViewCell.swift
//  GitHubExplorer
//
//  Created by Кирилл Юдин on 11/04/2019.
//  Copyright © 2019 Кирилл Юдин. All rights reserved.
//

import UIKit

class SearchResultTableViewCell: UITableViewCell {
    
    @IBOutlet weak var repositoryNameLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var repositoryDescriptionLabel: UILabel!
    @IBOutlet weak var authorAvatarImageView: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.authorAvatarImageView.image = nil
    }

}
