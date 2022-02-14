//
//  UserInfoViewController.swift
//  GithubFellows
//
//  Created by diayan siat on 19/12/2020.
//  Copyright © 2020 Diayan Siat. All rights reserved.
//

import UIKit

protocol UserInfoVCDelegate: class {
    func didRequestFollowers(for username: String)
}


class UserInfoViewController: UIViewController {
    
    let scrollView          = UIScrollView()
    let contentView         = UIView()
    let headerView          = UIView()
    let itemViewOne         = UIView()
    let itemViewTwo         = UIView()
    let dateLabel           = GFBodyLabel(textAlignment: .center)
    var itemViews: [UIView] = []
    
    var  username: String!
    weak var delegate: UserInfoVCDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureScrollView()
        layoutUI()
        getUserInfo()
    }
    
    func configureViewController() {
        view.backgroundColor              = .systemBackground
        let doneButton                    = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    //setup a scrollview to handle all items and views in the user info view scene
    func configureScrollView() {
        view.addSubviews(scrollView)
        scrollView.addSubviews(contentView) //views don't go into a scrollview directly. They always have to be in a contentView
        scrollView.pinToEdges(of: view)
        contentView.pinToEdges(of: scrollView)
        
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 600)
        ])
    }
    
    func getUserInfo() {
        NetworkManager.shared.getUserInfo(for: username!) { [weak self] result in
            guard let self      = self else {return}
            switch result {
            case .success(let user):
                DispatchQueue.main.async {self.configureUIElements(with: user)}
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "OK")
                print(error)
            }
        }
    }
    
    func configureUIElements(with user: User) {
        let repoItemVC          = GFRepoItemViewController(user: user)
        repoItemVC.delegate     = self
        let followerItemVC      = GFFollowerItemViewController(user: user)
        followerItemVC.delegate = self
        
        self.add(childVC: GFUserInfoHeaderVC.init(user: user), to: self.headerView)
        self.add(childVC: repoItemVC, to: self.itemViewOne)
        self.add(childVC: followerItemVC, to: self.itemViewTwo)
        self.dateLabel.text     = "GitHub since \(user.createdAt.convertToMonthYearFormat())"
    }
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }
    
    func layoutUI()  {
        let padding: CGFloat    = 20
        let itemHeight: CGFloat = 140
        itemViews               = [headerView, itemViewOne, itemViewTwo, dateLabel]
        
        for itemView in itemViews {
            contentView.addSubview(itemView)
            itemView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                itemView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
                itemView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            ])
        }
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: contentView.topAnchor), //constraint to safe area
            headerView.heightAnchor.constraint(equalToConstant: 210),
            
            itemViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
            itemViewOne.heightAnchor.constraint(equalToConstant: itemHeight),
            
            itemViewTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: padding),
            itemViewTwo.heightAnchor.constraint(equalToConstant: itemHeight),
            
            dateLabel.topAnchor.constraint(equalTo: itemViewTwo.bottomAnchor, constant: padding),
            dateLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func add(childVC: UIViewController, to containerView: UIView) {
        addChild(childVC) //adds child view controller to 
        containerView.addSubview(childVC.view) //container view here is the header view or any other search view
        childVC.view.frame      = containerView.bounds
        childVC.didMove(toParent: self)
    }
}

extension UserInfoViewController: GFRepoItemVCDelegate {
    func didTapGitHubProfile(for user: User) {
        //show safari Viewcontroller
        guard let url = URL(string: user.htmlUrl) else {
            presentGFAlertOnMainThread(title: "Invalid URL", message: "The url attached to this user is invalid", buttonTitle: "Ok")
            return
        }
        presentSafariVC(with: url)
    }
}

extension UserInfoViewController: GFFollowerItemVCDelegate {
    func didTapGetFollowers(for user: User) {
        //dismiss current vc
        //tell follower list screen the new user
        guard user.followers != 0 else {
            presentGFAlertOnMainThread(title: "No followers", message: "This user has no followers. What a shame 😞!", buttonTitle: "So sad")
            return
        }
        delegate.didRequestFollowers(for: user.login)
        dismissVC()
    }
}
