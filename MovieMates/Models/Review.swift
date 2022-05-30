//
//  Review.swift
//  MovieMates
//
//  Created by Joakim Andersson on 2022-05-05.
//

/**
 - Description: Here we create the review parameter.
 
 */

import Foundation

struct Review: Identifiable, Codable, Hashable {
    
    var id: String = UUID().uuidString //Unique id for each review
    let authorId: String
    let movieId: Int
    let rating: Int
    let reviewText: String
    let whereAt: String
    let withWho: String
    let likes: [String]
    let timestamp: Date
    
}
