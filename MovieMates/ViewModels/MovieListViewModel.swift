/**
 - Description:
    MovieListViewModel is a view model that handles the communication between the API and the corresponding views.
 
 - Authors:
    Karol Ö
    Oscar K
    Sarah L
    Joakim A
    Denis R
    Gustav S
 */

import Foundation
import Combine
import SwiftUI
import Alamofire

final class MovieListViewModel: ObservableObject {
    
    @Published var movies: [Movie] = []
    @Published var page: Int = 1
    @Published var totalPages: Int = 1
    @Published var infoText: String = "Type to search"
    @Published var movieListTitle = ""
    @Published var currentMovie: Movie? = nil
    var lastmovieId = 1
    
    var searchTerm: String = ""
    
    func onSearchTapped() {
        requestMovies(apiReuestType: .searchByTerm)
    }
    
    func onCancelTapped() {
        clearList()
    }
    
    func clearList() {
        movies.removeAll()
        page = 1
        totalPages = 1
        lastmovieId = 1
        infoText = "Type to search"
    }
    
    /// Request more data from API when currentItem is last movie id
    func loadMoreContent(currentItem item: Movie, apiRequestType: ApiRequestType){
        if lastmovieId == item.id, (page + 1) <= totalPages {
            page += 1
            requestMovies(apiReuestType: apiRequestType)
        }
    }
    
    /// Request more data from API
    func loadMoreContet(apiRequestType: ApiRequestType) {
        if (page+1 <= totalPages) {
            page += 1
            requestMovies(apiReuestType: apiRequestType)
        }
    }
    
    /// Creates API-request URL based on request type
    func requestMovies(apiReuestType: ApiRequestType){
        
        switch apiReuestType {
        case .searchByTerm:
            guard let encodedString  = searchTerm.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed), let apiUrl = URL(string: "\(BASE_API_URL)search/movie?api_key=\(API_KEY)&language=en-US&query=\(encodedString)&page=\(page)&include_adult=false")  else {
                print("invalid URL")
                return
            }
            movieListTitle = "Results"
            requestApi(url: apiUrl)
        case .popular:
            guard let apiUrl = URL(string: "\(BASE_API_URL)movie/popular?api_key=\(API_KEY)&language=en-US&page=\(page)") else {
                print("invalid URL")
                return
            }
            movieListTitle = "Popular"
            requestApi(url: apiUrl)
        case .upcoming:
            guard let apiUrl = URL(string: "\(BASE_API_URL)movie/upcoming?api_key=\(API_KEY)&language=en-US&page=\(page)") else {
                print("invalid URL")
                return
            }
            movieListTitle = "Upcoming"
            requestApi(url: apiUrl)
        case .nowPlaying:
            guard let apiUrl = URL(string: "\(BASE_API_URL)movie/now_playing?api_key=\(API_KEY)&language=en-US&page=\(page)") else {
                print("invalid URL")
                return
            }
            movieListTitle = "Now in cinema"
            requestApi(url: apiUrl)
        case .topRated:
            guard let apiUrl = URL(string: "\(BASE_API_URL)movie/top_rated?api_key=\(API_KEY)&language=en-US&page=\(page)") else {
                print("invalid URL")
                return
            }
            movieListTitle = "Top Rated"
            requestApi(url: apiUrl)
        }
    }
    
    /// Send API-request, appends result to movies Array
    func requestApi(url: URL) {
        AF.request(url).responseDecodable(of: APIMovieResponse.self) { responce in
            switch responce.result {
            case.success(let value):
                self.totalPages = value.total_pages ?? 1
                
                self.movies.append(contentsOf: value.results ?? [Movie]())
                self.lastmovieId = self.movies.last?.id ?? 1
                if self.movies.isEmpty {
                    self.infoText = "Nothing to display"
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

enum ApiRequestType {
    case searchByTerm
    case popular
    case upcoming
    case nowPlaying
    case topRated
}


