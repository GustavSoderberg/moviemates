//
//  User.swift
//  MovieMates
//
//  Created by Gustav Söderberg on 2022-05-04.
//

import Foundation
import FirebaseFirestoreSwift

struct User: Codable, Identifiable {
    
    @DocumentID var id : String?
    
    let username: String
    let photoUrl: URL
    let bio : String?
    
    let friends: [String]
    let frequests: [String]
    
    let themeId: Int
    
}
