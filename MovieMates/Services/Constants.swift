//
//  Constants.swift
//  MovieMates
//
//  Created by Denis Rakitin on 2022-05-08.
//
/**
 - Description:
 
 */

import Foundation
import Alamofire


let API_KEY = "db29946214e0864bc36c9884882f57f2"
let BASE_API_URL = "https://api.themoviedb.org/3/"
let HEADER: HTTPHeaders  = [
    "Content-Type" : "application/json; charset=utf-8"
]
let BACKDROP_BASE_URL  = "https://image.tmdb.org/t/p/w185"

let FRIENDS = "friends"
let TRENDING = "trending"
let POPULAR = "popular"
let UPCOMING = "upcoming"
let DISCOVER = "discover"
