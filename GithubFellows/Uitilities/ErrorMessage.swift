//
//  ErrorMessage.swift
//  GithubFellows
//
//  Created by diayan siat on 15/12/2020.
//  Copyright © 2020 Diayan Siat. All rights reserved.
//

import Foundation

//Raw value enums
enum GFError: String, Error {
    case invalidUsername = "This username created an invalid request. Please try again."
    case unableToComplete = "Unable to complete your request. Please check your internet connection"
    case invalidResponse = "Invalid response from the server. Please try again."
    case invalidData = "The data received from the server was invalid. Please try again."
}
