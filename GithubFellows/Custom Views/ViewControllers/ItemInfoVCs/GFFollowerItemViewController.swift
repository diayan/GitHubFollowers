//
//  GFFollowerItemViewController.swift
//  GithubFellows
//
//  Created by diayan siat on 25/12/2020.
//  Copyright © 2020 Diayan Siat. All rights reserved.
//

import UIKit

protocol GFFollowerItemVCDelegate: class {
    func didTapGetFollowers(for user: User)
}

class GFFollowerItemViewController: GFItemInfoViewController {
    weak var delegate: GFFollowerItemVCDelegate! //delegates should always be weak to avoid the retain cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }
    
    private func configureItems() {
        itemInfoViewOne.set(itemInfoType: .followers, with: user.followers)
        itemInfoViewTwo.set(itemInfoType: .following, with: user.following)
        actionButton.set(backgroundColor: .systemGreen, title: "Get Followers")
    }
    
    override func actionButtonTapped() {
        delegate.didTapGetFollowers(for: user)
    }
}
