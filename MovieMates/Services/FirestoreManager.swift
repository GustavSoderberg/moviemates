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
    }
    
    func saveUserToFirestore(user: User) {
        
        do {
            _ = try db.collection("users").addDocument(from: user)
        } catch {
            print("Error saving to db")
        }
    }
    
    func sendFriendRequest(from: User, to: User) -> Bool {
        
        if let id = to.documentId {
            
            db.collection("users").document(id)
                
                    .updateData([
                        
                        "frequests": FieldValue.arrayUnion([from.authId])
                        
                    ])
            
            return true
            
        }
        
        return false
        
    }
    
    func acceptFriendRequest(you: User, theirId: String) -> Bool {
        
        if let id = you.documentId {
            
            db.collection("users").document(id)
                
                    .updateData([
                        
                        "friends": FieldValue.arrayUnion([theirId]),
                        "frequests": FieldValue.arrayRemove([theirId])
                        
                    ])
            
            return true
            
        }
        
        return false
    }
    
    func removeFriend(you: User, theirId: String) -> Bool {
        
        if let id = you.documentId {
            
            db.collection("users").document(id)
                
                    .updateData([
                        
                        "friends": FieldValue.arrayRemove([theirId]),
                        
                    ])
            
            return true
            
        }
        
        return false
    }
}
