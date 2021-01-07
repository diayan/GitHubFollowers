//
//  GFRepoViewController.swift
//  GithubFellows
//
//  Created by diayan siat on 25/12/2020.
//  Copyright © 2020 Diayan Siat. All rights reserved.
//

import UIKit

protocol GFRepoItemVCDelegate: class {
    func didTapGitHubProfile(for user: User)
}

class GFRepoItemViewController: GFItemInfoViewController {
    weak var delegate: GFRepoItemVCDelegate! //delegates should always be weak to avoid the retain cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }
    
    private func configureItems() {
        itemInfoViewOne.set(itemInfoType: .repos, with: user.publicRepos)
        itemInfoViewTwo.set(itemInfoType: .gists, with: user.publicGists)
        actionButton.set(backgroundColor: .systemPurple, title: "GitHub Profile")
    }
    
    override func actionButtonTapped() {
        delegate.didTapGitHubProfile(for: user)
    }
}
