//
//  APIResponse.swift
//  MovieMates
//
//  Created by Denis Rakitin on 2022-05-08.
//

import Foundation

struct APIMovieResponse: Decodable {
    let id: Int?
    let results: [Movie]?
    let page: Int?
    let total_pages: Int?
    let total_results: Int?
}
