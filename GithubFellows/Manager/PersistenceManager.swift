//
//  PersistenceManager.swift
//  GithubFellows
//
//  Created by diayan siat on 27/12/2020.
//  Copyright © 2020 Diayan Siat. All rights reserved.
//

import Foundation

//the two actions are either to add or remove from user defaults
enum PersistenceActionType {
    case add, remove
}

enum PersistenceManager {
    static private let defaults = UserDefaults.standard
    
    enum Keys {
        //we could have more keys
        static let favorites = "favorites"
    }
    
    static func updateWith(favorite: Follower, actionType: PersistenceActionType, completed: @escaping (GFError?) -> Void) {
        retrieveFavorites { result in
            switch result {
            case .success(var favorites):
                switch actionType {
                case .add:
                    guard !favorites.contains(favorite) else {
                        completed(.alreadyInFavorites)
                        return
                    }
                    
                    favorites.append(favorite)
                    
                case .remove:
                    favorites.removeAll { $0.login == favorite.login }
                }
                
                completed(save(favorites: favorites))
                
            case .failure(let error):
                completed(error)
            }
        }
    }
    
    //Anytime you are saving a custom object to userdefaults you have to code and decode it
    //this function is used for retrieving from user defaults
    static func retrieveFavorites(completed: @escaping (Result<[Follower], GFError>) -> Void) {
        guard let favoritesData = defaults.object(forKey: Keys.favorites) as? Data else {
            completed(.success([])) //if user default is empty, return an empty list. This always happens at the beginning 
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let favorites = try decoder.decode([Follower].self, from: favoritesData)
            completed(.success(favorites))
        } catch {
            completed(.failure(.unableToFavorite))
        }
    }
    
    //this function is used for saving to user defaults
    static func save(favorites: [Follower]) -> GFError? {
        do {
            let encoder = JSONEncoder()
            let encodedFavorites = try encoder.encode(favorites)
            defaults.set(encodedFavorites, forKey: Keys.favorites)
            return nil
        } catch {
            return .unableToFavorite
        }
    }
}
