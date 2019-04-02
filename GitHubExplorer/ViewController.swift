//
//  ViewController.swift
//  GitHubExplorer
//
//  Created by Кирилл Юдин on 30/03/2019.
//  Copyright © 2019 Кирилл Юдин. All rights reserved.
//

import UIKit
import Kingfisher

class ViewController: UIViewController {

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let githubURL = URL(string: "https://github.githubassets.com/images/modules/logos_page/GitHub-Logo.png")
        logoImageView.kf.indicatorType = .activity
        logoImageView.kf.setImage(with: githubURL)
    }

    @IBAction func loginButtonPressed(_ sender: UIButton) {
    }
}

