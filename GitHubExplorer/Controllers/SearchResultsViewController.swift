//
//  SearchResultsViewController.swift
//  GitHubExplorer
//
//  Created by Кирилл Юдин on 10/04/2019.
//  Copyright © 2019 Кирилл Юдин. All rights reserved.
//

import UIKit

class SearchResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var repositoriesCountLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var searchResult: SearchResult?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        repositoriesCountLabel.text = "Repositories found: \(searchResult?.totalCount ?? 0)"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResult?.totalCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "repositoryTableViewCell") as? SearchResultTableViewCell,
            let foundedRepos = searchResult?.items else {
                return UITableViewCell()
        }
        
        let currentRepo = foundedRepos[indexPath.row]
        
        cell.repositoryNameLabel.text = currentRepo.name
        cell.repositoryDescriptionLabel.text = currentRepo.description
        cell.authorLabel.text = currentRepo.owner?.name
        
        cell.authorAvatarImageView.kf.indicatorType = .activity
        cell.authorAvatarImageView.kf.setImage(with: currentRepo.owner?.avatarURL, placeholder: UIImage(named: "placeholder"))
        
        return cell
    }
}

