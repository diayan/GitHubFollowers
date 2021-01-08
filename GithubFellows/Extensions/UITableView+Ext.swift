//
//  UITableView+Ext.swift
//  GithubFellows
//
//  Created by diayan siat on 07/01/2021.
//  Copyright © 2021 Diayan Siat. All rights reserved.
//

import UIKit

extension UITableView {
    
    func reloadDataOnMainThread() {
        DispatchQueue.main.async {
            self.reloadData()
        }
    }
    
    func removeExcessTableCells() {
        tableFooterView  = UIView(frame: .zero)
    }
}
