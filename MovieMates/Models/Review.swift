//
//  Review.swift
//  MovieMates
//
//  Created by Joakim Andersson on 2022-05-05.
//

import Foundation

struct Review: Identifiable, Codable {
    
    var id: String = UUID().uuidString //Unique id for each review
    let authorId: String
    let rating: Int
    let reviewText: String
    let whereAt: String
    let withWho: String
    let timestamp: Date
    
}
