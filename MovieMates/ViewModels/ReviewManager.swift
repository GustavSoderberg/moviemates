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
    
    func saveReview(movie: Movie, rating: Int, text: String, whereAt: String, withWho: String) {
        
        
        let review = Review(authorId: um.currentUser!.id!, movieId: movie.id, rating: rating, reviewText: text, whereAt: whereAt, withWho: withWho, timestamp: Date.now)
        if checkIfMovieExists(movieId: "\(movie.id)") {
            
            for movieFS in listOfMovieFS {
                if (movieFS.id! == "\(movie.id)")  {
                    
                    for (index, reviewFS) in movieFS.reviews.enumerated() {

                        if reviewFS.authorId == um.currentUser!.id {
                            
                            let newReview = Review(id: reviewFS.id, authorId: reviewFS.authorId, movieId: movie.id, rating: rating, reviewText: text, whereAt: whereAt, withWho: withWho, timestamp: Date.now)
                            
                            if fm.updateReviewToFirestore(movieId: "\(movie.id)", review: newReview, oldReview: reviewFS) {
                                print("Successfully found existing review")
                                break;
                            }
                        } else {
                            if fm.saveReviewToFirestore(movieId: "\(movie.id)", review: review) {
                                print("Successfully saved new review")
                                break;
                            }
                        }
                    }
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
    
    func getReview() -> Review {
        
        for movie in listOfMovieFS {
            for review in movie.reviews {
                if review.authorId == um.currentUser!.id! {
                    return review
                }
            }
        }
        
        return Review(id: "\(UUID())", authorId: um.currentUser!.id!, movieId: 0, rating: 0, reviewText: "", whereAt: "", withWho: "", timestamp: Date.now)
    }
    
    func getMovieFS(movieId: String) -> MovieFS? {
        
        for movieFS in listOfMovieFS {
            if movieFS.id == movieId {
                return movieFS
            }
        }
        return nil
    }
}

