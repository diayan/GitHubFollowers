//
//  GFFollowerItemViewController.swift
//  GithubFellows
//
//  Created by diayan siat on 25/12/2020.
//  Copyright © 2020 Diayan Siat. All rights reserved.
//

import UIKit

class GFFollowerItemViewController: GFItemInfoViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }
    
    private func configureItems() {
        itemInfoViewOne.set(itemInfoType: .following, with: user.following)
        itemInfoViewTwo.set(itemInfoType: .followers, with: user.followers)
        actionButton.set(backgroundColor: .systemGreen, title: "Get Followers")
    }
}
