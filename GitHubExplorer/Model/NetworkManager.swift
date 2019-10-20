//
//  NetworkManager.swift
//  GitHubExplorer
//
//  Created by Кирилл Юдин on 03/10/2019.
//  Copyright © 2019 Кирилл Юдин. All rights reserved.
//

import Foundation

enum NetworkManagerError : Error {
    case urlError
    case responseStatusError
    case noDataReceivedError
    case jsonDecoderError
}

class NetworkManager {
    
    private let sheme = "https"
    private let host  = "api.github.com"
    private let timeoutInterval = 30.0
    
    func loginAndGetCurrentUserData(base64AuthString: String, completionHandler: @escaping (Bool, Error?, User?) -> ()) {
        guard let userURL = url(path: "/user", queryItems: nil) else {
            completionHandler(false, NetworkManagerError.urlError, nil)
            
            return
        }
        
        let headers = ["Authorization": "Basic " + base64AuthString];
        let userRequest = request(url: userURL, timeoutInterval: timeoutInterval, headers: headers)
        
        let getUserDataTask = URLSession.shared.dataTask(with: userRequest) { (data, response, error) in
            guard error == nil else {
                completionHandler(false, error!, nil)
                
                return
            }
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completionHandler(false, NetworkManagerError.responseStatusError, nil)
                
                return
            }
            
            if let data = data {
                if let user = try? JSONDecoder().decode(User.self, from: data) {
                    completionHandler(true, nil, user)
                } else {
                    completionHandler(false, NetworkManagerError.jsonDecoderError, nil)
                }
            } else {
                completionHandler(false, NetworkManagerError.noDataReceivedError, nil)
            }
        }
        
        getUserDataTask.resume()
    }
    
    func search(mainWord: String, language: String, completionHandler: @escaping (Bool, Error?, SearchResult?) -> ()) {
        let queryItems = [ URLQueryItem(name: "q", value: mainWord + "+language:" + language) ]
                       
        guard let url = url(path: "/search/repositories", queryItems: queryItems) else {
            completionHandler(false, NetworkManagerError.urlError, nil)
            
            return
        }
        
        let headers = ["Accept" : "application/vnd.github.mercy-preview+json"]
        let urlRequest = request(url: url, timeoutInterval: timeoutInterval, headers: headers)

        let searchDataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil else {
                completionHandler(false, error!, nil)
                
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completionHandler(false, NetworkManagerError.responseStatusError, nil)
                
                return
            }
            
            if let data = data {
                guard let searchResult = try? JSONDecoder().decode(SearchResult.self, from: data) else {
                    completionHandler(false, NetworkManagerError.jsonDecoderError, nil)
                    
                    return
                }
                
                completionHandler(true, nil, searchResult)
            } else {
                completionHandler(false, NetworkManagerError.noDataReceivedError, nil)
            }
        }
        
        searchDataTask.resume()
        
    }
    
    private func url(path: String?, queryItems: [URLQueryItem]?) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = sheme
        urlComponents.host   = host
        
        if let path = path {
            urlComponents.path = path
        }
        
        if let queryItems = queryItems {
            urlComponents.queryItems = queryItems
        }
        
        return urlComponents.url
    }
    
    private func request(url: URL, timeoutInterval: Double, headers: [String : String]?) -> URLRequest {
        var urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: timeoutInterval)

        urlRequest.allHTTPHeaderFields = headers
        urlRequest.allowsCellularAccess = true
        urlRequest.httpMethod = "GET"
        
        return urlRequest
    }
}

