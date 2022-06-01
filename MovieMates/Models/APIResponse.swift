/**
 - Description:
    APIMovieResponse represents an object to be decoded from the API response.
 
 - Authors:
    Karol Ö
    Oscar K
    Sarah L
    Joakim A
    Denis R
    Gustav S
 */

import Foundation

struct APIMovieResponse: Decodable {
    let id: Int?
    let results: [Movie]?
    let page: Int?
    let total_pages: Int?
    let total_results: Int?
}
