//
//  UserInfoViewController.swift
//  GithubFellows
//
//  Created by diayan siat on 19/12/2020.
//  Copyright © 2020 Diayan Siat. All rights reserved.
//

import UIKit

protocol UserInfoVCDelegate: class {
    func didTapGitHubProfile(for user: User)
    func didTapGetFollowers(for user: User)
}

class UserInfoViewController: UIViewController {
    
    let headerView          = UIView()
    let itemViewOne         = UIView()
    let itemViewTwo         = UIView()
    let dateLabel           = GFBodyLabel(textAlignment: .center)
    var itemViews: [UIView] = []
    
    var  username: String!
    weak var delegate: FollowerListVCDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        layoutUI()
        getUserInfor()
    }
    
    func configureViewController() {
        view.backgroundColor              = .systemBackground
        let doneButton                    = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    func getUserInfor() {
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
            view.addSubview(itemView)
            itemView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                itemView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
                itemView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            ])
        }
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor), //constraint to safe area
            headerView.heightAnchor.constraint(equalToConstant: 180),
            
            itemViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
            itemViewOne.heightAnchor.constraint(equalToConstant: itemHeight),
            
            itemViewTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: padding),
            itemViewTwo.heightAnchor.constraint(equalToConstant: itemHeight),
            
            dateLabel.topAnchor.constraint(equalTo: itemViewTwo.bottomAnchor, constant: padding),
            dateLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
    
    func add(childVC: UIViewController, to containerView: UIView) {
        addChild(childVC) //adds child view controller to 
        containerView.addSubview(childVC.view) //container view here is the header view or any other search view
        childVC.view.frame      = containerView.bounds
        childVC.didMove(toParent: self)
    }
}

extension UserInfoViewController: UserInfoVCDelegate {
    func didTapGitHubProfile(for user: User) {
        //show safari Viewcontroller
        guard let url = URL(string: user.htmlUrl) else {
            presentGFAlertOnMainThread(title: "Invalid URL", message: "The url attached to this user is invalid", buttonTitle: "Ok")
            return
        }
        presentSafariVC(with: url)
    }
    
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
