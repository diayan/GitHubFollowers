//
//  NetworkManager.swift
//  GithubFellows
//
//  Created by diayan siat on 08/12/2020.
//  Copyright © 2020 Diayan Siat. All rights reserved.
//

import UIKit

class NetworkManager {
    static let shared   = NetworkManager() //initialize network manager
    private let baseURL         = "https://api.github.com/users/"
    //implementing caching in for our images
    let cache           = NSCache<NSString, UIImage>()
    
    
    //restrict it to only one instance
    private init() {}
    
    
    func getFollowers(for username: String, page: Int, completed: @escaping (Result<[Follower], GFError>) -> Void) {
        
        let endpoint = baseURL + "\(username)/followers?per_page=100&page=\(page)"
        
        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidUsername))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase //converts json from snake case to camelcase
                let followers = try decoder.decode([Follower].self, from: data)
                completed(.success(followers))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        //this starts the whole network process
        task.resume()
    }
    
    func getUserInfo(for username: String, completed: @escaping (Result<User, GFError>) -> Void) {
        
        let endpoint = baseURL + "\(username)"
        
        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidUsername))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy  = .convertFromSnakeCase //converts json from snake case to camelcase
                decoder.dateDecodingStrategy = .iso8601 //converts string date to standard date 
                let user                     = try decoder.decode(User.self, from: data)
                completed(.success(user))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        //this starts the whole network process
        task.resume()
    }
}
