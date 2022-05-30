//
//  MovieFS.swift
//  MovieMates
//
//  Created by Gustav Söderberg on 2022-05-16.
//

import Foundation
import FirebaseFirestoreSwift

struct MovieFS: Codable, Identifiable, Equatable {
    static func ==(lhs: MovieFS, rhs: MovieFS) -> Bool {
        return lhs.id == rhs.id
        }
    
    @DocumentID var id : String?
    
    var title: String
    var photoUrl: URL
    var rating: Double
    var description: String
    var reviews: [Review]
    
}
