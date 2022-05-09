//
//  MovieViewModel.swift
//  MovieMates
//
//  Created by Joakim Andersson on 2022-05-09.
//

import Foundation
import Alamofire

struct MovieViewModel {
    
    static let shared = MovieViewModel()
    
    private init(){}
    
    func fetchMovie(id: Int, completion: @escaping(Result<Movie, Error>) -> Void){
        let request = AF.request("\(BASE_API_URL)/movie/\(id)?api_key=\(API_KEY)&language=en-US&page=1")
        
        request.responseDecodable(of: Movie.self) { (response) in
            switch response.result {
            case.success(let movie):
                completion(Result.success(movie))
            case.failure(let error):
                completion(Result.failure(error))
            }
        }
    }
}
