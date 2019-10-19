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
    
    static var shared: NetworkManager {
        return NetworkManager()
    }
    
    private init() { }
    
    func loginAndGetCurrentUserData(base64AuthString: String, completionHandler: @escaping (Bool, Error?, User?) -> ()) {
        guard let userURL = url(path: "/user", queryItems: nil) else {
            completionHandler(false, NetworkManagerError.urlError, nil)
            
            return
        }
        
        let headers = ["Authorization": "Basic " + base64AuthString];
        let userRequest = request(url: userURL, timeoutInterval: 30.0, headers: headers)
        
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
        
        if let headers = headers {
            urlRequest.allHTTPHeaderFields = headers
        }
        
        urlRequest.allowsCellularAccess = true
        urlRequest.httpMethod = "GET"
        
        return urlRequest
    }
}

