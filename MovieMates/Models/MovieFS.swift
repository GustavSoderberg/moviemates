/**
 - Description:
    MovieFS is a Movie object to be decoded & stored in firebase
 
 - Authors:
    Karol Ö
    Oscar K
    Sarah L
    Joakim A
    Denis R
    Gustav S
 */

import Foundation
import FirebaseFirestoreSwift

struct MovieFS: Codable, Identifiable, Equatable {
    static func ==(lhs: MovieFS, rhs: MovieFS) -> Bool {
        return lhs.id == rhs.id
        }
    
    @DocumentID var id : String?
    
    var title: String
    var photoUrl: URL
    var rating: Double
    var description: String
    var reviews: [Review]
    
}
