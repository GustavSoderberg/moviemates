/**
 - Description:
    ReviewManager is a view model that handles the communication between displaying reviews and firebase.
 
 - Authors:
    Karol Ö
    Oscar K
    Sarah L
    Joakim A
    Denis R
    Gustav S
 */

import Foundation

class ReviewManager : ObservableObject {
    
    @Published var listOfMovieFS = [MovieFS]()
    @Published var refresh = 0
    @Published var cacheGlobal : Float = 0.0
    @Published var cacheFriends : Float = 0.0
    @Published var dismissedSpoiler = [String]()
    @Published var expandedReview = [String]()
    
    private let movieViewModel: MovieViewModel = MovieViewModel.shared
    
    //Returns a review array consisting of all review objects from each movies, also option to include only friends
    func getAllReviews(onlyFriends: Bool) -> [Review] {
        
        var reviewArray = [Review]()
        for movie in listOfMovieFS {
            
            if onlyFriends {
                for review in movie.reviews {
                    if um.currentUser!.friends.contains(review.authorId) {
                        reviewArray.append(review)
                    }
                }
            } else {
                
                for review in movie.reviews {
                    reviewArray.append(review)
                }
            }
        }
        
        return reviewArray.sorted(by: { $0.timestamp > $1.timestamp })
    }
    
    //Returns a review array consisting of reviews from a specific movie, also options to include only friends/yourself
    func getMovieReviews(movieId: Int, onlyFriends: Bool, includeSelf: Bool) -> [Review] {
        
        var reviewArray = [Review]()
        for movie in listOfMovieFS {
            if "\(movieId)" == movie.id!{
                if onlyFriends {
                    for review in movie.reviews {
                        if um.currentUser!.friends.contains(review.authorId) || (includeSelf && um.currentUser!.id == review.authorId) {
                            reviewArray.append(review)
                        }
                    }
                } else {
                    
                    return movie.reviews.sorted(by: { $0.timestamp > $1.timestamp })
                    
                }
            }
        }
        
        return reviewArray.sorted(by: { $0.timestamp > $1.timestamp })
    }
    
    //Returns a single review from a movie based on review id
    func getReview(movieId: String) -> Review {
        
        for movie in listOfMovieFS {
            if movie.id == movieId {
                for review in movie.reviews {
                    if review.authorId == um.currentUser!.id! {
                        return review
                    }
                }
            }
        }
        
        return Review(id: "\(UUID())", authorId: um.currentUser!.id!, movieId: 0, rating: 0, reviewText: "", whereAt: "", withWho: "", likes: [""], timestamp: Date.now)
    }
    
    //Returns a review array consisting of reviews from a specific user
    func getUsersReviews(user: User) -> [Review] {
        var reviewArray = [Review]()
        
        for movieFS in listOfMovieFS {
            for review in movieFS.reviews {
                if (user.id == review.authorId) {
                    reviewArray.append(review)
                }
            }
        }
        return reviewArray.sorted(by: { $0.timestamp > $1.timestamp })
    }
    
    //Calculates and returns the average rating of a user based on its total score and review amount
    func getUserAverageRating(user: User) -> Float {
        let reviewArray = getUsersReviews(user: user)
        var sum: Float = 0
        for review in reviewArray {
            sum += Float(review.rating)
        }
        let result: Float = sum/Float(reviewArray.count)
        return Float(result)
    }
    
    //Calculates the average of a movie based on its total score and review amount with an option for only friends
    func getAverageRating(movieId: Int, onlyFriends: Bool) -> Float {
        let allReviews = getMovieReviews(movieId: movieId, onlyFriends: onlyFriends, includeSelf: true)
        var totalScore: Int = 0
        if allReviews.count == 0 {
            return 0.0
        } else {
            for review in allReviews {
                totalScore += review.rating
            }
            print("number of ratings: \(allReviews.count) only friends: \(onlyFriends)")
        }
        return round(Float(totalScore)/Float(allReviews.count) * 100) / 100.0
    }
    
    //Checks if a movie object already exists
    func checkIfMovieExists(movieId: String) -> Bool {
        
        for movieFS in listOfMovieFS {
            if movieFS.id == movieId {
                return true
                
            }
        }
        return false
    }
    
    //Saves a review to a movie object depending if the movie already exists in our database(which is matched with our listOfMovieFS) either retrieves and appends the new review and overwrites the current movie object.
    //Otherwise a new movieFS object is created with the new review and stored to firebase
    func saveReview(movie: Movie, rating: Int, text: String, whereAt: String, withWho: String) {
        
        if checkIfMovieExists(movieId: "\(movie.id)") {
            
            let review = Review(authorId: um.currentUser!.id!, movieId: movie.id, rating: rating, reviewText: text, whereAt: whereAt, withWho: withWho, likes: [String]() , timestamp: Date.now)
            
            var reviews = getMovieReviews(movieId: movie.id, onlyFriends: false, includeSelf: false)
            
            for (index, review1) in reviews.enumerated() {
                if review1.authorId == um.currentUser!.id! {
                    reviews.remove(at: index)
                    break;
                }
            }
            
            reviews.append(review)
            
            if fm.updateReviewsToFirestore(movieId: "\(movie.id)", reviews: reviews) {
                print("Successfully created a new movie with the new review")
            } else {
                print("E: ReviewManager - saveReview() Failed to create a new movie + add the review")
            }
        } else {
            
            let review = Review(authorId: um.currentUser!.id!, movieId: movie.id, rating: rating, reviewText: text, whereAt: whereAt, withWho: withWho, likes: [String](), timestamp: Date.now)
            
            var reviews = getMovieReviews(movieId: movie.id, onlyFriends: false, includeSelf: false)
            reviews.append(review)
            
            if fm.saveMovieToFirestore(movieFS: MovieFS(id: "\(movie.id)", title: movie.title!, photoUrl: movie.posterURL, rating: Double(rating), description: movie.overview!, reviews: reviews)) {
                print("Successfully added the review to an existing movie")
            } else {
                print("E: ReviewManager - saveReview() Failed to add review to an existing movie")
            }
        }
    }

    //Returns a movieFS object based on a movieId
    func getMovieFS(movieId: String) -> MovieFS? {
        
        for movieFS in listOfMovieFS {
            if movieFS.id == movieId {
                return movieFS
            }
        }
        return nil
    }
  
    //This is a function for displaying grouped reviews if the previous review were written on the same movie, thus we want to display them in a grouped view instead of duplicate movie cards
    //Determines if the movie id is the same as the previous id and if so appends the review to a nested array
    //Otherwise returns a nested array consisting of just one review
    func groupReviews(reviews: [Review]) -> [[Review]] {
        var layerdReviewsArray: [[Review]] = [[]]
        var posAtLayerdArray = 0
        for i in 0..<reviews.count {
            let newReview = reviews[i]
            if i > 0 {
                if newReview.movieId == reviews[i-1].movieId {
                    layerdReviewsArray[posAtLayerdArray].append(newReview)
                } else {
                    posAtLayerdArray += 1
                    let nextReviews = [newReview]
                    layerdReviewsArray.append(nextReviews)
                }
            } else {
                layerdReviewsArray[posAtLayerdArray].append(newReview)
            }
        }
        return layerdReviewsArray
    }
    
    // To like/dislike a review, we retrieve the review and appends/removes the matching like of the user id
    // Then proceeds to retrieve and modify the existing review from firebase and makes the adjustments which is then overwritten as a review object to firebase
    func toggleLike(review: Review, removeLike: Bool) {
        var likes = review.likes
        if removeLike {
            for (index, likes1) in likes.enumerated() {
                if likes1 == um.currentUser!.id! {
                    likes.remove(at: index)
                    refresh += 1
                    break;
                }
            }
        } else {
            likes.append(um.currentUser!.id!)
            refresh += 1
        }
        var reviews = rm.getMovieReviews(movieId: review.movieId, onlyFriends: false, includeSelf: false)
        
        let newReview = Review(id: review.id, authorId: review.authorId, movieId: review.movieId, rating: review.rating, reviewText: review.reviewText, whereAt: review.whereAt, withWho: review.withWho, likes: likes, timestamp: review.timestamp)
        
        for (index, review1) in reviews.enumerated() {
            if review1.authorId == review.authorId {
                reviews.remove(at: index)
                reviews.insert(newReview, at: index)
                refresh += 1
                break;
            }
        }
        
        if fm.updateReviewsToFirestore(movieId: "\(review.movieId)", reviews: reviews) {
            print("Successfully added like")
        } else {
            print("E: ReviewManager - saveReview() Failed to add like")
        }
    }
}

