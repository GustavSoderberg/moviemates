//
//  Movie.swift
//  MovieMates
//
//  Created by Joakim Andersson on 2022-05-05.
//

import Foundation

struct Movie: Identifiable, Codable {
    
//    var id = UUID()
//    var title: String
//    var description: String
    let id: Int
    let adult: Bool?
    let backdropPath: String?
    let genreIDS: [Int]?
    let originalLanguage: String?
    let originalTitle: String?
    let overview: String?
    let releaseDate: String?
    let posterPath: String?
    let popularity: Double?
    let title: String?
    let video: Bool?
    let voteAverage, voteCount: Double?

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview
        case releaseDate = "release_date"
        case posterPath = "poster_path"
        case popularity
        case video
        case title
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
    
    var posterURL: URL {
        return URL(string: "https://image.tmdb.org/t/p/w500\(posterPath ?? "")")!
    }
    
    var backdropURL: URL {
        return URL(string: "https://image.tmdb.org/t/p/w500\(backdropPath ?? "")")!
    }
    
}
