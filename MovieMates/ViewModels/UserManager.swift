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
    @Published var refresh = 0
    
    func register(username: String) {
        
        let user = User(id: Auth.auth().currentUser!.uid, username: username, photoUrl: Auth.auth().currentUser!.photoURL!, bio: "Hello! I am new here 📺.", friends: [String](), frequests: [String](), themeId: 0)
        
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
                
                if user.id == Auth.auth().currentUser!.uid {
                    
                    um.currentUser = user
                    if um.isLoading { print("Logged in as \(user.username)") }
                    
                    return true
                    
                }
                
            }
            
            print("⚠️ New user detected ⚠️")
            return false
            
        }
        
    }
    
    func friendRequest(from: User, to: User) {
        
        if from.friends.contains(to.id!){
            print("\(to.id!) is already your friend")
        }
        else if to.frequests.contains(from.id!){
            print("You've already sent a friend request to this user")
        }
        else if !to.frequests.contains(from.id!) && fm.sendFriendRequest(from: from, to: to) {
            print("✔️ Successfully sent the friend request")
        }
        else {
            print("E: UserManager - friendRequest() Failed to send the request")
        }
        
    }
    
    func manageFriendRequests(sender: String, accept: Bool) {
        
        if accept {
            
            if fm.acceptFriendRequest(you: currentUser!, theirId: sender) {
                print("✔️ Successfully added user as a friend")
            }
            
            else {
                print("E: UserManager - manageFriendRequests() Failed to add the friend")
            }
        }
        else {
            
            
        }
        
    }
    
    func removeFriend(userId: String) {
        
        if fm.removeFriend(you: um.currentUser!, theirId: userId) {
            print("✔️ Successfully removed friend")
        }
        else {
            print("E: UserManager - removeFriend() Failed to remove user")
        }
        
        
    }
    
}
