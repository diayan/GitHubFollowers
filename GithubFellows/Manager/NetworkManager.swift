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
    private let baseURL = "https://api.github.com/users/"
    let cache           = NSCache<NSString, UIImage>() //implementing caching for to cache our images
    
    private init() {} //restrict NetworkManager class to only one instance i.e: a singleton
    
    func getFollowers(for username: String, page: Int, completed: @escaping (Result<[Follower], GFError>) -> Void) {
        let endpoint  = baseURL + "\(username)/followers?per_page=100&page=\(page)"
        
        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidUsername))
            return
        }
        
        let task      = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let _  = error {
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data     = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder   = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase //converts json from snake case to camelcase
                let followers = try decoder.decode([Follower].self, from: data)
                completed(.success(followers))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        task.resume()//this starts the whole network process
    }
    
    func getUserInfo(for username: String, completed: @escaping (Result<User, GFError>) -> Void) {
        let endpoint  = baseURL + "\(username)"
        
        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidUsername))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let _  = error {
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data     = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder    = JSONDecoder()
                decoder.keyDecodingStrategy  = .convertFromSnakeCase //converts json from snake case to camelcase
                decoder.dateDecodingStrategy = .iso8601 //converts string date to standard date 
                let user                     = try decoder.decode(User.self, from: data)
                completed(.success(user))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        task.resume()//this starts the whole network process
    }
    
    //downloads image into an imageview
    func downloadImage(from urlString: String, completed: @escaping (UIImage?) -> Void) {
        let cacheKey        = NSString(string: urlString)
        //check if image exists in cache, if it does, don't do a network call to download
        if let image        = cache.object(forKey: cacheKey) {
            completed(image)
            return
        }
        
        guard let url       = URL(string: urlString) else {
            completed(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            //A combined guard let to handle a nil response for all cases. this prevents repeition
            guard let self        = self,
                  error           == nil,
                  let response    = response as? HTTPURLResponse, response.statusCode == 200,
                  let data        = data,
                  let image       = UIImage(data: data) else {
                completed(nil)
                return
            }
            self.cache.setObject(image, forKey: cacheKey) //put image in cache so that the next time it is not downloaded
            completed(image)
        }
        task.resume()
    }
}
