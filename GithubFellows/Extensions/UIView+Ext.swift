//
//  UIView+Ext.swift
//  GithubFellows
//
//  Created by diayan siat on 07/01/2021.
//  Copyright © 2021 Diayan Siat. All rights reserved.
//

import UIKit

extension UIView {
    
    func pinToEdges(of superview: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.topAnchor),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor)
        ])
    }
    
    //the dots make it a variadic function, which means we can add any number of parameters. 'views' becomes an array
    func addSubviews(_ views: UIView...) {
        for view in views {
            addSubview(view)
        }
    }
}
