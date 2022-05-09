//
//  MovieListViewModel.swift
//  MovieMates
//
//  Created by Denis Rakitin on 2022-05-08.
//

import Foundation
import Combine
import SwiftUI
import Alamofire

final class MovieListViewModel: ObservableObject {

    @Published var isLoading: Bool = false
    @Published var movies: [Movie] = []
    @Published var page: Int = 1

    var searchTerm: String = ""

    func onSearchTapped() {
        requestMovies(searchTerm: searchTerm)
    }

    private func requestMovies(searchTerm: String){
        
        guard let url = URL(string: "https://api.themoviedb.org/3/search/movie?api_key=\(API_KEY)&language=en-US&query=\(searchTerm)&page=1&include_adult=false")  else {return}
        
        AF.request(url).responseDecodable(of: APIMovieResponse.self) { responce in
                switch responce.result {
                case.success(let value):
                    self.movies = value.results ?? [Movie]()
                case .failure(let error):
                    print(error)
                }
            }
        }
}


