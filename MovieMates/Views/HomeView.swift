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

struct HomeView: View {
    @AppStorage("darkmode") private var darkmode = true
    @EnvironmentObject var statusController: StatusController
    
    @State var index = TRENDING
    @State var showMovieView = false
    @State var showProfileView = false
    @State var currentMovie: Movie? = nil
    @State var presentMovie: Movie? = nil
    @State var isUpcoming = false
    @State var userProfile: User? = nil
    
    @ObservedObject var viewModel = MovieListViewModel()
    @ObservedObject var orm = rm
    
    var body: some View {
        
        ZStack{
            Color("background")
                .ignoresSafeArea()
            
            VStack(spacing: 0){
                
                HStack {
                    Image("moviemates")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .overlay(RoundedRectangle(cornerRadius: 75).stroke(.black, lineWidth: 2))
                    
                    Text("Movie Mates")
                        .font(.title)
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 5)
                
                Picker(selection: $index, label: Text("Review List"), content: {
                    Text("Friends").tag(FRIENDS)
                    Text("Trending").tag(TRENDING)
                    Text("Discover").tag(DISCOVER)
                    
                })
                .padding(.horizontal)
                .padding(.top, 10)
                .pickerStyle(SegmentedPickerStyle())
                .colorMultiply(Color(ACCENT_COLOR))
                
                ScrollView{
                    VStack {
                        switch index {
                        case FRIENDS:
                            if orm.getAllReviews(onlyFriends: true).isEmpty {
                                Text("No Friends")
                                Button {
                                    statusController.searchIndex = "users"
                                    statusController.selection = 3
                                } label: {
                                    Text("Add more friends")
                                        .padding(.horizontal)
                                        .padding(.vertical, 4)
                                        .cornerRadius(5)
                                        .font(Font.headline.weight(.bold))
                                        .font(.system(size: 15))
                                        .background(LinearGradient(gradient: Gradient(colors: [Color(GRADIENT_TOP), Color(GRADIENT_BOTTOM)]), startPoint: .top, endPoint: .bottom)
                                            .mask(Rectangle()
                                                .cornerRadius(5))
                                                .shadow(radius: 6))
                                        .foregroundColor(darkmode ? .white : .black)
                                }
                            } else {
                                ForEach(orm.groupReviews(reviews: orm.getAllReviews(onlyFriends: true)), id: \.self) { reviews in
                                    if reviews.count == 1 {
                                        ReviewCard(review: reviews[0], movieFS: rm.getMovieFS(movieId: "\(reviews[0].movieId)"), currentMovie: $currentMovie, showMovieView: $showMovieView, userProfile: $userProfile, showProfileView: $showProfileView, displayName: true, displayTitle: true, blurSpoiler: !rm.dismissedSpoiler.contains(reviews[0].id))
                                    } else {
                                        GroupHeader(reviews: reviews, currentMovie: $currentMovie, showMovieView: $showMovieView, userProfile: $userProfile, showProfileView: $showProfileView, blurSpoiler: true)
                                    }
                                }
                            }
                            
                        case TRENDING:
                            ForEach(orm.groupReviews(reviews: orm.getAllReviews(onlyFriends: false)), id: \.self) { reviews in
                                if !reviews.isEmpty {
                                    if reviews.count == 1 {
                                        ReviewCard(review: reviews[0], movieFS: rm.getMovieFS(movieId: "\(reviews[0].movieId)"), currentMovie: $currentMovie, showMovieView: $showMovieView, userProfile: $userProfile, showProfileView: $showProfileView, displayName: true, displayTitle: true, blurSpoiler: !rm.dismissedSpoiler.contains(reviews[0].id))
                                    } else {
                                        GroupHeader(reviews: reviews, currentMovie: $currentMovie, showMovieView: $showMovieView, userProfile: $userProfile, showProfileView: $showProfileView, blurSpoiler: true)
                                    }
                                }
                            }
                            
                        case DISCOVER:
                            DicoverView()
                        default:
                            ForEach(friendsReviews) { review in
                                ReviewCard(review: review, movieFS: rm.getMovieFS(movieId: "\(review.movieId)"), currentMovie: $currentMovie, showMovieView: $showMovieView, userProfile: $userProfile, showProfileView: $showProfileView, displayName: true, displayTitle: true, blurSpoiler: true)
                            }
                        }
                    }
                    .padding()
                    .sheet(isPresented: $showMovieView) {
                        
                        if let currentMovie = currentMovie {
                            MovieViewController(movie: currentMovie, isUpcoming: isUpcoming, showMovieView: $showMovieView)
                            
                                .preferredColorScheme(darkmode ? .dark : .light)
                        }
                    }
                    .sheet(isPresented: $showProfileView) {
                        if let userProfile = userProfile {
                            ProfileView(user: userProfile)
                                .preferredColorScheme(darkmode ? .dark : .light)
                        }
                    }
                }
            }
        }.onAppear {
            statusController.searchIndex = MOVIES
        }
    }
}



func formatDate(date: Date) -> String{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "d MMMM yyyy"
    return dateFormatter.string(from: date)
}


private var friendsReviews = [Review]()

private var trendingReviews = [Review]()
