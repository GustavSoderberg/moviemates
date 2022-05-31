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
    @Published var viewShowing: Status = .Loading
    @Published var selection = 2
    @Published var searchIndex = "movies"
}

enum Status {
    case Loading, WelcomeView, HomeView
}
