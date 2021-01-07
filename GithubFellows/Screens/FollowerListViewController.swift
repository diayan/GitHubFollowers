//
//  FollowerListViewController.swift
//  GithubFellows
//
//  Created by diayan siat on 10/11/2020.
//  Copyright © 2020 Diayan Siat. All rights reserved.
//

import UIKit

class FollowerListViewController: GFDataLoadingVC {
    
    //collection view could have more than one section ie the divisions in the collection view
    enum Section {case main}
    
    var username: String!
    var followers: [Follower]         = []
    var filteredFollowers: [Follower] = []
    var page                          = 1
    var hasMoreFollowers              = true
    var isSearching                   = false
    var isLoadingMoreFollowers        = false
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!
    
    init(username: String) {
        super.init(nibName: nil, bundle: nil)
        self.username = username
        title         = username
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        view.backgroundColor              = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let addButton                     = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc func addButtonTapped() {
        showLoadingView()
        NetworkManager.shared.getUserInfo(for: username) { [weak self] result in
            guard let self = self else {return}
            self.dismissLoadingView()
            
            switch result {
            case .success(let user):
                let favorite = Follower(login: user.login, avatarUrl: user.avatarUrl)
                
                PersistenceManager.updateWith(favorite: favorite, actionType: .add){ [weak self] error in
                    guard let self = self else { return }
                    
                    guard let error = error else {
                        self.presentGFAlertOnMainThread(title: "Success!", message: "You have successfully added \(user.login) to favorites 🥳.", buttonTitle: "Hooray!")
                        return
                    }
                    self.presentGFAlertOnMainThread(title: "Something went wrong.", message: error.rawValue, buttonTitle: "Ok")
                }
                break
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
            break
            }
        }
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
        searchController.searchBar.placeholder                = "Search for a username"
        searchController.obscuresBackgroundDuringPresentation = false //remove overlay on controller
        navigationItem.searchController                       = searchController
    }
    
    func getFollowers(username: String, page: Int) {
        showLoadingView()
        isLoadingMoreFollowers  = true
        //[weak self] is a called a capture list
        NetworkManager.shared.getFollowers(for: username, page: page) { [weak self] result in
            //anytime you make something weak, it becomes an optional
            guard let self      = self else {return}
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
            self.isLoadingMoreFollowers = false
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
            //check if user has more followers and previous request is finished before incrementing the page 
            guard hasMoreFollowers, !isLoadingMoreFollowers else {return}
            page += 1
            getFollowers(username: username, page: page)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let activeFollowers = isSearching ? filteredFollowers : followers //W ? T : F. if isSearching is true use filteredFollowers else normal followers
        let follower        = activeFollowers[indexPath.item]
        let desVC           = UserInfoViewController()
        desVC.username      = follower.login
        desVC.delegate      = self
        let navController   = UINavigationController(rootViewController: desVC)
        present(navController, animated: true)
        }
}

extension FollowerListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter  = searchController.searchBar.text, !filter.isEmpty else {
            filteredFollowers.removeAll()
            updateData(on: followers)
            isSearching   = false
            return
        } //check that the search bar is not empty
        isSearching       = true //change isSearching to true
        filteredFollowers = followers.filter{$0.login.lowercased().contains(filter.lowercased())}
        updateData(on: filteredFollowers)
    }
    
    //NOTE:: We do not need this again, same funciton is acheived in the guard let filter statement above
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        //when a user clicks on cancel, call the followers list again!
//        updateData(on: followers)
//        isSearching        = false //set isSearching to false onece a user cancels
//    }
}

extension FollowerListViewController: UserInfoVCDelegate {
    func didRequestFollowers(for username: String) {
        // get followers for user
        self.username     = username
        title             = username
        page              = 1 //reset page number since it's a brand new member
        followers.removeAll()
        filteredFollowers.removeAll()
        //scroll collection view back to the top
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
        getFollowers(username: username, page: page)
    }
}
