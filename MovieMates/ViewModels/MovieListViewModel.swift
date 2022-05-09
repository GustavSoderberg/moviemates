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

    @Published var movies: [Movie] = []
    @Published var page: Int = 1
    @Published var totalPages: Int = 1
    var lastmovieId = 1

    var searchTerm: String = ""

    func onSearchTapped() {
        requestMovies(searchTerm: searchTerm)
    }
    
    func onCancelTapped() {
        movies.removeAll()
        page = 1
        totalPages = 1
        lastmovieId = 1
    }
    
    func loadMoreContent(currentItem item: Movie){
//        let thresholdIndex = self.movies.index(self.movies.endIndex, offsetBy: -1)
        if lastmovieId == item.id, (page + 1) <= totalPages {
            page += 1
            requestMovies(searchTerm: searchTerm)
        }
    }

    private func requestMovies(searchTerm: String){
        
        guard let url = URL(string: "https://api.themoviedb.org/3/search/movie?api_key=\(API_KEY)&language=en-US&query=\(searchTerm)&page=\(page)&include_adult=false")  else {return}
        
        AF.request(url).responseDecodable(of: APIMovieResponse.self) { responce in
                switch responce.result {
                case.success(let value):
                    self.totalPages = value.total_pages ?? 1
                    
                    self.movies.append(contentsOf: value.results ?? [Movie]())
                    self.lastmovieId = self.movies.last?.id ?? 1
                case .failure(let error):
                    print(error)
                }
            }
        }
}


