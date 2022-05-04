//
//  User.swift
//  MovieMates
//
//  Created by Gustav Söderberg on 2022-05-04.
//

import Foundation

struct User {
    
    let username: String
    let photoUrl: URL
    let bio : String?
    
    let friendsArray: [String]?
    let themeId: Int
    
}
