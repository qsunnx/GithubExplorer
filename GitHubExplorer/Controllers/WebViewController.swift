//
//  WebViewController.swift
//  GitHubExplorer
//
//  Created by Кирилл Юдин on 11.10.2019.
//  Copyright © 2019 Кирилл Юдин. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    var repo_url: URL?
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self        

        if let url = repo_url {
            let repoRequest = URLRequest(url: url)
            
            webView.load(repoRequest)
        }
    }

}

extension WebViewController : WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let source = "document.body.style.background=\"#31bd8e\";"
        webView.evaluateJavaScript(source) { (result, error) in
            guard error == nil else {
                print(error!)
                
                return
            }
        }
    }
}
