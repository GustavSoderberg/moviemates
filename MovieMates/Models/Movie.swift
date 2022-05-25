//
//  Movie.swift
//  MovieMates
//
//  Created by Joakim Andersson on 2022-05-05.
//

import Foundation

struct Movie: Identifiable, Codable, Hashable {
    static func == (lhs: Movie, rhs: Movie) -> Bool {
        lhs.id == rhs.id
    }
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
    
    
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
    let genres: [MovieGenre]?
    
    
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
        case genres
    }
    
    var posterURL: URL {
        return URL(string: "https://image.tmdb.org/t/p/w500\(posterPath ?? "")")!
    }
    
    var backdropURL: URL {
        return URL(string: "https://image.tmdb.org/t/p/w500\(backdropPath ?? "")")!
    }
    
}

struct MovieGenre: Codable {
    
    let name: String
}
