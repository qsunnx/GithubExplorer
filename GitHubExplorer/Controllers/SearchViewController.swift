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
    
    var username: String?
    var userAvatarURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let username = username {
            usernameLabel.text = "Hello, \(username)!"
        }
        
        let processor = RoundCornerImageProcessor(cornerRadius: 20.0)
        let placeholder = UIImage(named: "placeholder")
        userAvatarImageView.kf.setImage(with: userAvatarURL, placeholder: placeholder, options: [.processor(processor)])
    }
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        guard let mainWord = mainWordTextField.text, let language = languageTextField.text else {
            print("Need to print text in mainWordTextField or languageTextField!")
            return
        }

        guard mainWord.count > 0, language.count > 0 else {
            print("Need to print text in mainWordTextField or languageTextField!")

            return
        }
        
        NetworkManager().search(mainWord: mainWord, language: language) { (result, error, searchResult) in
            guard result, let searchResult = searchResult else { return }
            
            DispatchQueue.main.async {
                let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                let searchResultsVC = storyboard.instantiateViewController(withIdentifier: "searchResultsVC") as! SearchResultsViewController
                
                searchResultsVC.searchResult = searchResult
                
                self.navigationController?.pushViewController(searchResultsVC, animated: false)
            }
        }
//
//        let networkManager = NetworkManager()
//        let queryItems = [URLQueryItem(name: "q", value: mainWordTextField.text! + "+language:" + languageTextField.text!)]
//
//        guard let url = networkManager.url(path: "/search/repositories", queryItems: queryItems) else {
//            return
//        }
//
//        let headers = ["Accept" : "application/vnd.github.mercy-preview+json"]
//        let urlRequest = networkManager.request(url: url, timeoutInterval: 30.0, headers: headers)
//
//        let urlSession = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
//            if error != nil {
//                print("URLSession error: \(error.debugDescription)")
//                return
//            }
//
//            if let data = data {
//                var searchResult: SearchResult?
//
//                do {
//                    searchResult = try JSONDecoder().decode(SearchResult.self, from: data)
//                } catch {
//                    print("Error while decoding JSON from server: \(error)")
//                }
//
//                DispatchQueue.main.async {
//                    let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
//                    let searchResultsVC = storyboard.instantiateViewController(withIdentifier: "searchResultsVC") as! SearchResultsViewController
//
//                    searchResultsVC.searchResult = searchResult
//
//                    self.navigationController?.pushViewController(searchResultsVC, animated: false)
//                }
//            }
//        }
//
//        urlSession.resume()
        
    }
}


