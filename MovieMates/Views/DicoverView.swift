/**
 - Description:
 Our main view consists of three views displayed in tabs
 
 ProfileView:
 The first is for the profileView where information is about the current user.  In this view we can see our own reviews that we have made, our watchlist, friendlist and current user information.  In the information tab we can view a user's bio and see their statistics (including yourself).
 
 HomeView:
 Second is the homeView where we have three tabs. Here we can find reviews that friends have made but also a tab where reviews from the whole app can be shown.
 There's also a Discover view with popular, upcoming, cinema and top rated movies displayed in a coverflow or a list (whichever you prefer)
 
 SearchView:
 The third tab is searchView, where you can search for movies/series as well as a user you would like to view.
 
 
 - Authors:
    Karol Ö
    Oscar K
    Sarah L
    Joakim A
    Denis R
    Gustav S
 
 */

import SwiftUI


struct DicoverView: View {
    
    @AppStorage("darkmode") private var darkmode = true
    
    var body: some View {
        ScrollView(.vertical){
            VStack {
                CarouselSection(movieListType: .popular)
                CarouselSection(movieListType: .upcoming)
                CarouselSection(movieListType: .nowPlaying)
                CarouselSection(movieListType: .topRated)
            }
        }
        .frame(maxHeight: .infinity)
    }
}

struct DicoverView_Previews: PreviewProvider {
    static var previews: some View {
        DicoverView()
    }
}
