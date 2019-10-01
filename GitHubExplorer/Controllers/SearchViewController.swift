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
    
    private let headers = ["Accept" : "application/vnd.github.mercy-preview+json"]
    private let sheme   = "https"
    private let host    = "api.github.com"
    private let path    = "/search/repositories"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let processor = RoundCornerImageProcessor(cornerRadius: 20.0)
        let url = URL(string: "https://img.icons8.com/ios/120/000000/contacts.png")
        userAvatarImageView.kf.setImage(with: url, placeholder: nil, options: [.processor(processor)])
    }
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        guard mainWordTextField.text != nil, languageTextField.text != nil else {
            print("Need to print text in mainWordTextField or languageTextField!")
            return
        }
        
        guard mainWordTextField.text!.count > 0, languageTextField.text!.count > 0 else {
            print("Need to print text in mainWordTextField or languageTextField!")
            
            return
        }
        
        var urlComponents = URLComponents()
        urlComponents.scheme = sheme
        urlComponents.host = host
        urlComponents.path = path
        
        urlComponents.queryItems = [
            URLQueryItem(name: "q", value: mainWordTextField.text! + "+language:" + languageTextField.text!)
        ]
        
        guard let url = urlComponents.url else {
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.allHTTPHeaderFields = headers
        urlRequest.timeoutInterval = 30
        
        let urlSession = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if error != nil {
                print("URLSession error: \(error.debugDescription)")
                return
            }
            
            if let data = data {
                var searchResult: SearchResult?
                
                do {
                    searchResult = try JSONDecoder().decode(SearchResult.self, from: data)
                } catch {
                    print("Error while decoding JSON from server: \(error)")
                }

                DispatchQueue.main.async {
                    let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                    let searchResultsVC = storyboard.instantiateViewController(withIdentifier: "searchResultsVC") as! SearchResultsViewController
                    
                    searchResultsVC.searchResult = searchResult
                    
                    self.navigationController?.pushViewController(searchResultsVC, animated: false)
                }
            }
        }
        
        urlSession.resume()
        
    }
}


