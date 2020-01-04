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
    
    override func viewDidAppear(_ animated: Bool) {
        do {
            try SecureManager().getFromKeychain() { [weak self] (success, errorMessage, login, password) in
                if success { self?.githubAuthorization(login: login, password: password) }
                else {
                    print(errorMessage)
                }
            }
        } catch KeychainError.noPassword(let description) {
            print(description)
        } catch KeychainError.unexpectedPasswordData(let description) {
            print(description)
        } catch KeychainError.unhandledError(let status) {
            print("Ошибка keychain \(status.description)")
        } catch LocalAuthError.policyError(let description) {
            print(description)
        } catch {
            print("Неустановленная ошибка")
        }
    }

    @IBAction func loginButtonPressed(_ sender: UIButton) {
        guard let login = loginTextField.text, let password = passwordTextField.text else {
            return
        }

        guard login.count > 0, password.count > 0 else {
            return
        }
        
        githubAuthorization(login: login, password: password)
    }
    
    private func githubAuthorization(login: String, password: String) {
        let authString = login + ":" + password

        guard let utf8AuthString = authString.data(using: .utf8) else {
            print("Ошибка преобразования строки в utf8")
            return
        }

        let base64AuthString = utf8AuthString.base64EncodedString()
        let networkManager = NetworkManager()
        
        networkManager.loginAndGetCurrentUserData(base64AuthString: base64AuthString) { (success, error, user) in
            guard success, let currentUser = user else { return }
            
            // TODO: здесь обрабатывать ошибку внутреннюю
            if let passwordData = password.data(using: .utf8) {
                _ = SecureManager().saveToKeychain(login: login, password: passwordData)
            }
            
            DispatchQueue.main.async {
                let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                guard let searchViewController = mainStoryboard.instantiateViewController(withIdentifier: "searchVC") as? SearchViewController else {
                    return
                }
                
                searchViewController.username = currentUser.login
                
                if let avatarURLString = currentUser.avatar_url, let avatarURL = URL(string: avatarURLString) {
                    searchViewController.userAvatarURL = avatarURL
                }
                
                self.navigationController?.pushViewController(searchViewController, animated: false)
            }
        }
    }
}

