/**
 - Description:
    User is a model for a User object
 
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

struct User: Codable, Identifiable {
    
    @DocumentID var id : String?
    
    let username: String
    let photoUrl: URL
    let bio : String?
    
    let friends: [String]
    let frequests: [String]
    let watchlist: [String]
    
    let themeId: Int
    
}
