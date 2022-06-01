/**
 - Description:
    Review is a model for a Review object
 
 - Authors:
    Karol Ö
    Oscar K
    Sarah L
    Joakim A
    Denis R
    Gustav S
 */

import Foundation

struct Review: Identifiable, Codable, Hashable {
    
    var id: String = UUID().uuidString //Unique id for each review
    let authorId: String
    let movieId: Int
    let rating: Int
    let reviewText: String
    let whereAt: String
    let withWho: String
    let likes: [String]
    let timestamp: Date
    
}
