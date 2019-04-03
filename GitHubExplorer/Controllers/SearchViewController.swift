//
//  SearchViewController.swift
//  GitHubExplorer
//
//  Created by Кирилл Юдин on 03/04/2019.
//  Copyright © 2019 Кирилл Юдин. All rights reserved.
//

import UIKit
import Kingfisher

class SearchViewController: UIViewController {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userAvatarImageView: UIImageView!
    @IBOutlet weak var mainWordTextField: UITextField!
    @IBOutlet weak var languageTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let processor = RoundCornerImageProcessor(cornerRadius: 20.0)
        let url = URL(string: "https://img.icons8.com/ios/120/000000/contacts.png")
        userAvatarImageView.kf.setImage(with: url, placeholder: nil, options: [.processor(processor)])
    }
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
    }
}
