//
//  FirestoreManager.swift
//  MovieMates
//
//  Created by Gustav Söderberg on 2022-05-05.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class FirestoreManager {
    
    let db = Firestore.firestore()
    
    func listenToFirestore() {
        db.collection("users").addSnapshotListener { snapshot, err in
            
            guard let snapshot = snapshot else { return }
            
            if let err = err {
                print("Error getting user document \(err)")
                
            } else {
                um.listOfUsers.removeAll()
                
                for document in snapshot.documents {
                    let result = Result {
                        
                        try document.data(as: User.self)
                        
                    }
                    
                    switch result {
                    case.success(let user) :
                        
                        um.listOfUsers.append(user!)
                        
                    case.failure(let error) :
                        print("Error decoding user \(error)")
                    }
                }
                
                _ = um.login()
                
                um.refresh += 1
                um.isLoading = false
                
            }
        }
        
        db.collection("movies").addSnapshotListener { snapshot, err in
            
            guard let snapshot = snapshot else { return }
            
            if let err = err {
                print("Error getting user movieFS object \(err)")
                
            } else {
                rm.listOfMovieFS.removeAll()
                
                for document in snapshot.documents {
                    let result = Result {
                        
                        try document.data(as: MovieFS.self)
                        
                    }
                    
                    switch result {
                    case.success(let user) :
                        
                        rm.listOfMovieFS.append(user!)
                        
                    case.failure(let error) :
                        print("Error decoding movieFS \(error)")
                    }
                }
                
                rm.refresh += 1
                
            }
        }
    }
    
    func saveUserToFirestore(user: User) {
        
        do {
            _ = try db.collection("users").document(user.id!).setData(from: user)
        } catch {
            print("Error saving to db")
        }
    }
    
    func sendFriendRequest(from: User, to: User) -> Bool {
        
        if from.id != nil && to.id != nil {
            
            db.collection("users").document(to.id!)
                
                    .updateData([
                        
                        "frequests": FieldValue.arrayUnion([from.id!])
                        
                    ])
            
            return true
            
        }
        
        return false
        
    }
    
    func acceptFriendRequest(you: User, newFriendId: String) -> Bool {
        
        if you.id != nil {
            
            db.collection("users").document(you.id!)
                
                    .updateData([
                        
                        "frequests": FieldValue.arrayRemove([newFriendId]),
                        "friends": FieldValue.arrayUnion([newFriendId])
                        
                    ])
            
            db.collection("users").document(newFriendId)
                
                    .updateData([
                        
                        "friends": FieldValue.arrayUnion([you.id!])
                        
                    ])
            
            return true
            
        }
            
        return false
        
    }
    
    func denyFriendRequest(you: User, denyFriendId: String) -> Bool {
        
        if you.id != nil {
            
            db.collection("users").document(you.id!)
                
                    .updateData([
                        
                        "frequests": FieldValue.arrayRemove([denyFriendId])
                        
                    ])
            
            return true
            
        }
            
        return false
        
    }
    
    func removeFriend(you: User, removeUserId: String) -> Bool {
        
        if you.id != nil {
            
            db.collection("users").document(you.id!)
                
                    .updateData([
                        
                        "friends": FieldValue.arrayRemove([removeUserId]),
                        
                    ])
            
            db.collection("users").document(removeUserId)
                
                    .updateData([
                        
                        "friends": FieldValue.arrayRemove([you.id!]),
                        
                    ])
            
            return true
            
        }
        
        return false
        
    }
    
    func changeUsername(you: User, username: String) -> Bool {
        
        db.collection("users").document(you.id!)
            
                .updateData([
                    
                    "username": username
                    
                ])
        
        return true
        
    }
    
    func updateBiography(you: User, biography: String) -> Bool {
        
        db.collection("users").document(you.id!)
            
                .updateData([
                    
                    "bio": biography
                    
                ])
        
        return true
        
    }
    
    func saveMovieToFirestore(movieFS: MovieFS) -> Bool{
        
        do {
            try db.collection("movies").document(movieFS.id!).setData(from: movieFS)
            return true
        }
        catch {
            return false
        }
        
    }
    
    func saveReviewToFirestore(movieId: String, review: Review) {
        
            db.collection("movies").document(movieId)
            
                .updateData([
                    
                    "reviews": FieldValue.arrayUnion([review])
                    
                ])
        
    }
}
