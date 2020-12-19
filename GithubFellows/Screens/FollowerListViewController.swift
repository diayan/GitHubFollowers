//
//  FollowerListViewController.swift
//  GithubFellows
//
//  Created by diayan siat on 10/11/2020.
//  Copyright © 2020 Diayan Siat. All rights reserved.
//

import UIKit

class FollowerListViewController: UIViewController {
    
    //collection view could have more than one section ie the divisions in the collection view
    enum Section {case main}
    
    var username: String!
    var followers: [Follower]         = []
    var filteredFollowers: [Follower] = []
    var page                          = 1
    var hasMoreFollowers              = true
    var isSearching                   = false
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureCollectionView()
        getFollowers(username: username, page: page)
        configureDataSource()
        configureSearchController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func configureViewController() {
        view.backgroundColor            = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.delegate         = self
        collectionView.backgroundColor  = .systemBackground
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseId)
    }
    
    func configureSearchController() {
        let searchController                                  = UISearchController()
        searchController.searchResultsUpdater                 = self
        searchController.searchBar.delegate                   = self
        searchController.searchBar.placeholder                = "Search for a username"
        searchController.obscuresBackgroundDuringPresentation = false //remove overlay on controller
        navigationItem.searchController                       = searchController
    }
    
    func getFollowers(username: String, page: Int) {
        showLoadingView()
        //[weak self] is a called a capture list
        NetworkManager.shared.getFollowers(for: username, page: page) { [weak self] result in
            //anytime you make something weak, it becomes an optional
            guard let self = self else {return}
            self.dismissLoadingView()
            switch result{
            case .success(let followers):
                if followers.count < 100 {self.hasMoreFollowers = false}
                self.followers.append(contentsOf: followers)
                if self.followers.isEmpty {
                    let message = "\(self.username!) doesn't have any followers. Go follow them 😀."
                    DispatchQueue.main.async {
                        self.showEmptyStateView(with: message, in: self.view)
                        return //after showing an empty view, do nothing else 
                    }
                }
                self.updateData(on: followers)

            case .failure(let error ):
                self.presentGFAlertOnMainThread(title: "Bad stuff happened", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, follower) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseId, for: indexPath) as! FollowerCell
            cell.set(follower: follower)
            return cell
        })
    }
    
    func updateData(on followers: [Follower]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        DispatchQueue.main.async {self.dataSource.apply(snapshot, animatingDifferences: true)}
    }
}

extension FollowerListViewController: UICollectionViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY       = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height        = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            guard hasMoreFollowers else {return}
            page += 1
            getFollowers(username: username, page: page)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let activeFollowers = isSearching ? filteredFollowers : followers //W ? T : F. if isSearching is true use filteredFollowers else normal followers
        let follower        = activeFollowers[indexPath.item]
        let desVC           = UserInfoViewController()
        desVC.username      = follower.login
        let navController   = UINavigationController(rootViewController: desVC)
        present(navController, animated: true)
        }
}

extension FollowerListViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter  = searchController.searchBar.text, !filter.isEmpty else {return} //check that the search bar is not empty
        isSearching       = true //change isSearching to true
        filteredFollowers = followers.filter{$0.login.lowercased().contains(filter.lowercased())}
        updateData(on: filteredFollowers)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //when a user clicks on cancel, call the followers list again!
        updateData(on: followers)
        isSearching        = false //set isSearching to false onece a user cancels
    }
}
