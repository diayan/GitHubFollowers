//
//  GFItemInfoView.swift
//  GithubFellows
//
//  Created by diayan siat on 25/12/2020.
//  Copyright © 2020 Diayan Siat. All rights reserved.
//

import UIKit

//different use cases for the GFItemInfoView created below
enum itemInfoType {
    case repos, gists, followers, following
}

class GFItemInfoView: UIView {
    let symbolImageView  = UIImageView()
    let titleLabel       = GFTitleLabel(textAlignment: .left, fontSize: 14)
    let countLablel      = GFTitleLabel(textAlignment: .center, fontSize: 14)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubview(titleLabel)
        addSubview(countLablel)
        addSubview(symbolImageView)
        
        //it is done for only imageview because the others have been done in thir sub-classes
        symbolImageView.translatesAutoresizingMaskIntoConstraints = false
        symbolImageView.contentMode = .scaleAspectFill
        symbolImageView.tintColor   = .label
        
        NSLayoutConstraint.activate([
            symbolImageView.topAnchor.constraint(equalTo: self.topAnchor),
            symbolImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            //setting width and height defines fixed size of the view
            symbolImageView.widthAnchor.constraint(equalToConstant: 20),
            symbolImageView.heightAnchor.constraint(equalToConstant: 20),
            
            titleLabel.centerYAnchor.constraint(equalTo: symbolImageView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: symbolImageView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 18),
            
            countLablel.topAnchor.constraint(equalTo: symbolImageView.bottomAnchor, constant: 4),
            countLablel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            countLablel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            countLablel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
    
    //this will be used to fomat the info view item based on the type
    func set(itemInfoType: itemInfoType, with count: Int) {
        switch itemInfoType {
        case .repos:
            symbolImageView.image  = UIImage(systemName: SFSymbols.repos)
            titleLabel.text        = "Public Repos"
        case .gists:
            symbolImageView.image  = UIImage(systemName: SFSymbols.gists)
            titleLabel.text        = "Public Gists"
        case .followers:
            symbolImageView.image  = UIImage(systemName: SFSymbols.followers)
            titleLabel.text        = "Followers"
        case .following:
            symbolImageView.image  = UIImage(systemName: SFSymbols.following)
            titleLabel.text        = "Following"
        }
        //count will always be based on what is passed in 
        countLablel.text           = String(count)
    }
    
}
