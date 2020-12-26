//
//  Date+Ext.swift
//  GithubFellows
//
//  Created by diayan siat on 26/12/2020.
//  Copyright © 2020 Diayan Siat. All rights reserved.
//

import Foundation

extension Date {
    func convertToMonthYearFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        return dateFormatter.string(from: self)
    }
}
