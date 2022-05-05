//
//  Movie.swift
//  MovieMates
//
//  Created by Joakim Andersson on 2022-05-05.
//

import Foundation

struct Movie: Identifiable {
    
    let id = UUID()
    let title: String
    let description: String
    
}
