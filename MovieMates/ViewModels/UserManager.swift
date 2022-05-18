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
    
    @Published var notification = false
    @Published var isLoading = true
    @Published var refresh = 0
    
    func register(username: String) {
        
        let user = User(id: Auth.auth().currentUser!.uid, username: username, photoUrl: Auth.auth().currentUser!.photoURL!, bio: "Hello! I am new here 📺.", friends: [String](), frequests: [String](), watchlist: [String](),  themeId: 0)
        
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
    
    func friendRequest(to: User) {
        
        if currentUser!.friends.contains(to.id!){
            print("\(to.id!) is already your friend")
        }
        else if to.frequests.contains(currentUser!.id!){
            print("You've already sent a friend request to this user")
        }
        else if !to.frequests.contains(currentUser!.id!) && fm.sendFriendRequest(from: currentUser!, to: to) {
            print("✔️ Successfully sent the friend request")
        }
        else {
            print("E: UserManager - friendRequest() Failed to send the request")
        }
        
    }
    
    func manageFriendRequests(forId: String, accept: Bool) {
        
        if accept {
            
            if fm.acceptFriendRequest(you: currentUser!, newFriendId: forId) {
                print("✔️ Successfully added user as a friend")
            }
            
            else {
                print("E: UserManager - manageFriendRequests() Failed to accept the friend request")
            }
        }
        else if !accept {
            
            if fm.denyFriendRequest(you: currentUser!, denyFriendId: forId) {
                print("✔️ Successfully added user as a friend")
            }
            
            else {
                print("E: UserManager - manageFriendRequests() Failed to deny the friend request")
            }
            
        }
        else {
            print("E: UserManager - manageFriendRequests() Failed handle the friend request")
        }
        
    }
    
    func removeFriend(id: String) {
        
        if fm.removeFriend(you: currentUser!, removeUserId: id) {
            print("✔️ Successfully removed friend")
        }
        else {
            print("E: UserManager - removeFriend() Failed to remove user")
        }
        
        
    }
    
    func changeUsername(username: String) {
        
        if fm.changeUsername(you: currentUser!, username: username) {
            print("✔️ Successfully changed username")
        }
        else {
            print("E: UserManager - changeUsername() Failed to change username")
        }
        
    }
    
    func updateBiography(biography: String) {
        
        if fm.updateBiography(you: currentUser!, biography: biography) {
            print("✔️ Successfully updated users biography")
        }
        else {
            print("E: UserManager - updateBiography() Failed to update biography")
        }
        
    }
    
    func getUser(id: String) -> User{
        
        for user in listOfUsers {
            if user.id == id {
                return user
                
            }
        }
        
                //Retunerar en testuser om if satsen misslyckas
        return User(id: "", username: "", photoUrl: URL(string: "no")!, bio: "", friends: ["",""], frequests: ["",""], watchlist: [""], themeId: 0)
    }
    
    func addToWatchlist(movieID: String){
        
        if fm.saveWatchlistToFirebase(user: um.currentUser!, movieID: movieID) {
            print("Succefully added movie to watchlist")
            
        }else{
            print("ERROR!! You did not succefully save the movie")
        }
         
    }
    
    func removeMovieWatchlist(movieID: String){
        
        if fm.removeMovieFromWatchlist(userID: um.currentUser!.id!, movieID: movieID) {
            print("Succefully removed movie to watchlist")
            
        }else{
            print("ERROR!! You did not succefully save the movie")
        }
         
    }
    
    func getMovie(movieID: String) -> MovieFS?{
        
        for movie in rm.listOfMovieFS {
            if movie.id == movieID {
                return movie
            }
            
        }
            return nil
    }
}
