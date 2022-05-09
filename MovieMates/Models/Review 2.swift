//
//  Review.swift
//  MovieMates
//
//  Created by Joakim Andersson on 2022-05-05.
//

import Foundation

struct Review: Identifiable {
    
    let id = UUID()
    let username: String
    let title: String
    let rating: String
    let reviewText: String
    let timestamp = Date.now
}
