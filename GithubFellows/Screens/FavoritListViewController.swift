//
//  FavoritListViewController.swift
//  GithubFellows
//
//  Created by diayan siat on 10/11/2020.
//  Copyright © 2020 Diayan Siat. All rights reserved.
//

import UIKit

class FavoritListViewController: GFDataLoadingVC {
    
    let tableView             = UITableView()
    var favorites: [Follower] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFavorites()
    }
    
    private func configureViewController(){
        view.backgroundColor = .systemBackground
        title                = "Favorites"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        
        tableView.frame      = view.bounds
        tableView.rowHeight  = 80
        tableView.delegate   = self
        tableView.dataSource = self
        tableView.removeExcessTableCells()
        
        tableView.register(FavoriteCell.self, forCellReuseIdentifier: FavoriteCell.reuseId)
    }
    
    func getFavorites() {
        PersistenceManager.retrieveFavorites { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let favorites):
                if favorites.isEmpty {
                    self.showEmptyStateView(with: "No favorites?\n Add one on the follower screen", in: self.view)
                }else {
                    self.favorites = favorites
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        //self.view.bringSubviewToFront(self.tableView) //bring back the tableview to the top. similar to z-index
                    }
                }
                
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
}

extension FavoritListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCell.reuseId) as! FavoriteCell
        let favorite = favorites[indexPath.row]
        cell.set(favorite: favorite)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favorite    = favorites[indexPath.row]
        let destVC      = FollowerListViewController(username: favorite.login)
        
        navigationController?.pushViewController(destVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else {return}
        //remove favorite from persistence
        PersistenceManager.updateWith(favorite: favorites[indexPath.row], actionType: .remove) { [weak self] error in
            guard let self  = self else {return}
            guard let error = error else {
                DispatchQueue.main.async {
                    self.favorites.remove(at: indexPath.row) //remove from local array
                    tableView.deleteRows(at: [indexPath], with: .left) //swipe to delete from tableview
                }
                return
            }
            self.presentGFAlertOnMainThread(title: "Unable to remove", message: error.rawValue, buttonTitle: "Ok")
        }
    }
}
