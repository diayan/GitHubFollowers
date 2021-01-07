//
//  UIView+Ext.swift
//  GithubFellows
//
//  Created by diayan siat on 07/01/2021.
//  Copyright © 2021 Diayan Siat. All rights reserved.
//

import UIKit

extension UIView {
    //the dots make it a variadic function, which means we can add any number of parameters. 'views' becomes an array
    func addSubviews(_ views: UIView...) {
        for view in views {
            addSubview(view)
        }
    }
}
