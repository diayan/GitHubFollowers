//
//  Follower.swift
//  GithubFellows
//
//  Created by diayan siat on 07/12/2020.
//  Copyright © 2020 Diayan Siat. All rights reserved.
//

import Foundation

struct Follower: Codable, Hashable {
    var login: String
    var avatarUrl: String
    
    //If we wanted to hash only login this is what we would do or avatarUrl
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(login)
//    }
}
