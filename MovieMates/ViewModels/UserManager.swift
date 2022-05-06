//
//  UserManager.swift
//  MovieMates
//
//  Created by Sarah Lidberg on 2022-05-04.
//

import Foundation
import FirebaseAuth

class UserManager: ObservableObject {
    
    var listOfUsers = [User]()
    var currentUser: User? = nil
    
    @Published var isLoading = true
    
    func register(username: String) {
        
        let user = User(authId: Auth.auth().currentUser!.uid, username: username, photoUrl: Auth.auth().currentUser!.photoURL!, bio: nil, friendsArray: nil, themeId: 0)
        
        fm.saveUserToFirestore(user: user)
        currentUser = user
        print("✔️ New user was successfully registred")
        
    }
    
    func login() -> Bool {
        
        if Auth.auth().currentUser == nil {
            
            print("⚠️ New device detected ⚠️")
            return false
            
        }
        else {
            for user in listOfUsers {
                
                if user.authId == Auth.auth().currentUser!.uid {
                    
                    um.currentUser = user
                    print("Logged in as \(user.username)")
                    
                    return true
                    
                }
                
            }
            
            print("⚠️ New user detected ⚠️")
            return false
            
        }
        
    }
    
}
