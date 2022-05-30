//
//  ReviewListViewModel.swift
//  MovieMates
//
//  Created by Joakim Andersson on 2022-05-18.
//


/**
 - Description:
 
 */

import Foundation

class ReviewListViewModel: ObservableObject {
    
    @Published var reviews = [Review]()
    
    func getAllReviews(){
        reviews.removeAll()
        for movieFS in rm.listOfMovieFS {
            reviews.append(contentsOf: movieFS.reviews)
        }
        reviews = reviews.sorted(by: { $0.timestamp.compare($1.timestamp) == .orderedDescending })
    }
    
    func getFriendsReviews(){
        reviews.removeAll()
        for movieFS in rm.listOfMovieFS {
            for review in movieFS.reviews {
                if um.currentUser!.friends.contains(review.authorId) {
                    reviews.append(review)
                }
            }
        }
    }
    
    func getUsersReviews(user: User){
        reviews.removeAll()
        for movieFS in rm.listOfMovieFS {
            for review in movieFS.reviews {
                if (user.id == review.authorId) {
                    reviews.append(review)
                }
            }
        }
    }
}
