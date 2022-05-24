//
//  HomeView.swift
//  MovieMates
//
//  Created by Gustav Söderberg on 2022-05-02.
//
import SwiftUI

struct HomeView: View {
    @AppStorage("darkmode") private var darkmode = true
    
    @State var index = "friends"
    @State var showMovieView = false
    @State var showProfileView = false
    @State var currentMovie: Movie? = nil
    @State var presentMovie: Movie? = nil
    @State var isUpcoming = false
    @State var userProfile: User? = nil
    
    @ObservedObject var viewModel = MovieListViewModel()
    @ObservedObject var allReviewsViewModel = ReviewListViewModel()
    @ObservedObject var friendsReviewsViewModel = ReviewListViewModel()
    @ObservedObject var orm = rm
    
    var body: some View {
        ZStack{
            Color("background")
                .ignoresSafeArea()
            
            VStack{
                Picker(selection: $index, label: Text("Review List"), content: {
                    Text("Friends").tag(FRIENDS)
                    Text("Trending").tag(TRENDING)
                    Text("Popular").tag(POPULAR)
                    Text("Upcoming").tag(UPCOMING)
                    
                })
                .padding(.horizontal)
                .padding(.top, 20)
                .pickerStyle(SegmentedPickerStyle())
                .colorMultiply(Color("accent-color"))
                
                ScrollView{
                    LazyVStack{
                        switch index {
                        case FRIENDS:
                            ForEach(orm.getAllReviews(onlyFriends: true), id: \.self) { review in
                                ReviewCard(review: review, movieFS: rm.getMovieFS(movieId: "\(review.movieId)"), currentMovie: $currentMovie, showMovieView: $showMovieView, displayName: true, displayTitle: true, showProfileView: $showProfileView, userProfile: $userProfile)
                            }
                        case TRENDING:
                            ForEach(orm.getAllReviews(onlyFriends: false), id: \.self) { review in
                                ReviewCard(review: review, movieFS: rm.getMovieFS(movieId: "\(review.movieId)"), currentMovie: $currentMovie, showMovieView: $showMovieView, displayName: true, displayTitle: true, showProfileView: $showProfileView, userProfile: $userProfile)

                            }
                            
                        case POPULAR:
                            ForEach(viewModel.movies, id: \.self) { movie in
                                MovieCardView(movie: movie, isUpcoming: isUpcoming)
                                    .onAppear(){
                                        viewModel.loadMoreContent(currentItem: movie, apiRequestType: .popular)
                                    }
                            }
                        case UPCOMING:
                            ForEach(viewModel.movies, id: \.self) { movie in
                                MovieCardView(movie: movie, isUpcoming: isUpcoming)
                                    .onAppear(){
                                        viewModel.loadMoreContent(currentItem: movie, apiRequestType: .upcoming)
                                    }
                            }
                            
                        default:
                            ForEach(friendsReviews) { review in

                                ReviewCard(review: review, currentMovie: $currentMovie, showMovieView: $showMovieView, displayName: true, displayTitle: true, showProfileView: $showProfileView, userProfile: $userProfile)

                            }
                        }
                    }
//                    .onAppear {
//                        viewModel.clearList()
//                        viewModel.requestMovies(apiReuestType: .popular)
//                    }
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
        }
        .onAppear {
            allReviewsViewModel.getAllReviews()
            friendsReviewsViewModel.getFriendsReviews()
        }
        .onChange(of: index, perform: { newValue in
            switch newValue {
            case POPULAR:
                viewModel.clearList()
                viewModel.requestMovies(apiReuestType: .popular)
                print("popular tab")
                
            case UPCOMING:
                viewModel.clearList()
                viewModel.requestMovies(apiReuestType: .upcoming)
                print("upcoming tab")
            default:
                break
            }
        })
    }
}


func formatDate(date: Date) -> String{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "d MMMM yyyy"
    return dateFormatter.string(from: date)
}


private var friendsReviews = [Review]()

private var trendingReviews = [Review]()
