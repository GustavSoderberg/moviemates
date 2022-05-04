//
//  UserManager.swift
//  MovieMates
//
//  Created by Sarah Lidberg on 2022-05-04.
//

import Foundation
import FirebaseAuth

class UserManager{
    
    var listOfUsers = [User]()
    var currentUser: User? = nil
    
    func register(username: String) {
        
        currentUser = User(username: username, photoUrl: Auth.auth().currentUser!.photoURL!, bio: nil, friendsArray: nil, themeId: 0)
        
    }
    
}
