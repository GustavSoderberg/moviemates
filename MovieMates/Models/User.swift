//
//  User.swift
//  MovieMates
//
//  Created by Gustav Söderberg on 2022-05-04.
//

import Foundation
import FirebaseFirestoreSwift

struct User: Codable, Identifiable {
    var id = UUID()
    
    
    @DocumentID var documentId : String?
    
    let authId: String
    let username: String
    let photoUrl: URL
    let bio : String?
    
    let friendsArray: [String]?
    let themeId: Int
    
}
