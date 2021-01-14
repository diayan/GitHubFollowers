//
//  GFUserInfoHeaderVC.swift
//  GithubFellows
//
//  Created by diayan siat on 20/12/2020.
//  Copyright © 2020 Diayan Siat. All rights reserved.
//

//where a re using child view controllers over a view because:
//1. They give us access to the lifecycle methods
//2. They are self contained
//3. They have a flexible context

import UIKit

class GFUserInfoHeaderVC: UIViewController {
    
    let avatarImageView   = GFAvatarImageView(frame: .zero)
    let userNameLabel     = GFTitleLabel(textAlignment: .left, fontSize: 34)
    let nameLabel         = GFSecondaryTitleLabel(fontSize: 18)
    let locationImageView = UIImageView()
    let locationLabel     = GFSecondaryTitleLabel(fontSize: 18)
    let bioLabel          = GFBodyLabel(textAlignment: .left)
    
    var user: User!
    
    init(user: User) {
        super.init(nibName: nil, bundle: nil)
        self.user = user
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubviews(
            avatarImageView,
            userNameLabel,
            nameLabel,
            locationLabel,
            locationImageView,
            bioLabel
        )
        layoutUI()
        configureUIElements()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUIElements() {
        downloadAvartarImage()
        userNameLabel.text     = user.login
        nameLabel.text         = user.name ?? ""
        locationLabel.text     = user.location ?? "No Location"
        bioLabel.text          = user.bio ?? "No bio"
        bioLabel.numberOfLines = 3
        
        locationImageView.image     = SFSymbols.location
        locationImageView.tintColor = .secondaryLabel
    }
    
    func downloadAvartarImage()  {
        NetworkManager.shared.downloadImage(from: user.avatarUrl) { [weak self] image in
            guard let self     = self else {return}
            DispatchQueue.main.async {
                self.avatarImageView.image = image
            }
        }
    }

    func layoutUI() {
        let padding: CGFloat          = 20
        let textImagePadding: CGFloat = 12 //padding between avatar and text labels around it
        locationImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
            avatarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 90),
            avatarImageView.heightAnchor.constraint(equalToConstant: 90),
            
            userNameLabel.topAnchor.constraint(equalTo: avatarImageView.topAnchor), //top to top of avartarimageview
            userNameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: textImagePadding),
            userNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            userNameLabel.heightAnchor.constraint(equalToConstant: 38),
            
            nameLabel.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: textImagePadding),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: 20),
            
            locationImageView.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor),
            locationImageView.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: textImagePadding),
            locationImageView.widthAnchor.constraint(equalToConstant: 20),
            locationImageView.heightAnchor.constraint(equalToConstant: 20),
            
            locationLabel.centerYAnchor.constraint(equalTo: locationImageView.centerYAnchor),
            locationLabel.leadingAnchor.constraint(equalTo: locationImageView.trailingAnchor, constant: 5),
            locationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            locationLabel.heightAnchor.constraint(equalToConstant: 20),
            
            bioLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: textImagePadding),
            bioLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            bioLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bioLabel.heightAnchor.constraint(equalToConstant: 90)
        ])
    }
}
