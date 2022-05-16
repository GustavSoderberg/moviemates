//
//  MovieFS.swift
//  MovieMates
//
//  Created by Gustav Söderberg on 2022-05-16.
//

import Foundation
import FirebaseFirestoreSwift

struct MovieFS: Codable, Identifiable {
    
    @DocumentID var id : String?
    
    var title: String
    var photoUrl: URL
    var rating: Double
    var description: String
    var reviews: [Review]
    
//    sum
//    amount
//    for review in movieFS && currentUser?.friends.contains(review.authorId){
//        for review in reviews {
//            sum += review.rating
//        }
//    }
//
//    amount = review.count
}
