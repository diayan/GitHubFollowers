//
//  UserInfoViewController.swift
//  GithubFellows
//
//  Created by diayan siat on 19/12/2020.
//  Copyright © 2020 Diayan Siat. All rights reserved.
//

import UIKit

class UserInfoViewController: UIViewController {

    var  username: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
        print(username!)
        
        NetworkManager.shared.getUserInfo(for: username!) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let user):
                print(user)
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "OK")
                print(error)
            }
        }
    }
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }
}
