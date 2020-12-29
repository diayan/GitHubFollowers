//
//  GFAlertContainerView.swift
//  GithubFellows
//
//  Created by diayan siat on 29/12/2020.
//  Copyright © 2020 Diayan Siat. All rights reserved.
//

import UIKit

class GFAlertContainerView: UIView {
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        backgroundColor    = .systemBackground //gives it a background color of white
        layer.cornerRadius = 16
        layer.borderWidth  = 2
        layer.borderColor  = UIColor.white.cgColor
        translatesAutoresizingMaskIntoConstraints = false
    }
}
