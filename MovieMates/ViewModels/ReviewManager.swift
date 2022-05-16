//
//  ReviewManager.swift
//  MovieMates
//
//  Created by Gustav Söderberg on 2022-05-16.
//

import Foundation

class ReviewManager : ObservableObject {
    
    @Published var listOfMovieFS = [MovieFS]()
    @Published var refresh = 0
    
    func getReviews(movieId: Int, onlyFriends: Bool) -> [Review] {
        
        var reviewArray = [Review]()
        for movie in listOfMovieFS {
            
            if "\(movieId)" == movie.id!{
                
                if onlyFriends {
                    
                    for review in movie.reviews {
                        
                        if um.currentUser!.friends.contains(review.authorId) {
                            
                            reviewArray.append(review)
                            
                        }
                        
                    }
                }
                else {
                    
                    return movie.reviews
                    
                    
                }
                
            }
            
        }
        
        return reviewArray
    }
    
    func checkIfMovieExists(movieId: String) -> Bool {

        for movieFS in listOfMovieFS {
            
            if movieFS.id == movieId {
                
                return true
                
            }
        }
        
        return false
        
    }
    
    func saveReview(movie: Movie, rating: Int, text: String, cinema: String, friends: String) {
        
        
        let review = Review(authorId: um.currentUser!.id!, rating: rating, reviewText: text, whereAt: cinema, withWho: friends, timestamp: Date.now)
        if checkIfMovieExists(movieId: "\(movie.id)") {
            
            for movieFS in listOfMovieFS {
                if (movieFS.id! == "\(movie.id)")  {
                    fm.saveReviewToFirestore(movieId: "\(movie.id)", review: review)
                }
            }
        }
        else {
            
            
            
            if fm.saveMovieToFirestore(movieFS: MovieFS(id: "\(movie.id)", title: movie.title!, photoUrl: movie.posterURL, rating: Double(rating), description: movie.overview!, reviews: [review]), review: review) {
                
                print("Successfully saved new movieFS + Review")
            }
            else {
                print("E: ReviewManager - saveReview() Failed to create MovieFS object and save review")
            }
            
        }
        
    }
    
}
