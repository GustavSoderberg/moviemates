/**
 - Description:
    MovieViewModel is a view model that handles the communication specifically to fetch a movie.
 
 - Authors:
    Karol Ö
    Oscar K
    Sarah L
    Joakim A
    Denis R
    Gustav S
 */

import Foundation
import Alamofire

struct MovieViewModel {
    
    static let shared = MovieViewModel()
    
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
