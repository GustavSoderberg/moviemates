/**
 - Description: StatusController handles all the parameters for which view to display
 
 - Authors:
    Karol Ö
    Oscar K
    Sarah L
    Joakim A
    Denis R
    Gustav S
 */

import Foundation

class StatusController: ObservableObject {
    
    /// Loading-, Welcome-, and HomeView
    @Published var viewShowing: Status = .Loading
    
    /// Profile-, Home-, and SearchView
    @Published var selection = 2
    
    /// SearchView: Movies or Users
    @Published var searchIndex = "movies"
}

enum Status {
    case Loading, WelcomeView, HomeView
}
