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
    @State var currentMovie: Movie? = nil
    
    @ObservedObject var viewModel = MovieListViewModel()
    @ObservedObject var allReviewsViewModel = ReviewListViewModel()
    @ObservedObject var friendsReviewsViewModel = ReviewListViewModel()
    
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
                            ForEach(friendsReviewsViewModel.reviews) { review in
                                ReviewCard(review: review, movieFS: rm.getMovieFS(movieId: "\(review.movieId)"), currentMovie: $currentMovie, showMovieView: $showMovieView, displayName: true, displayTitle: true)
                            }
                        case TRENDING:
                            ForEach(allReviewsViewModel.reviews) { review in
                                ReviewCard(review: review, movieFS: rm.getMovieFS(movieId: "\(review.movieId)"), currentMovie: $currentMovie, showMovieView: $showMovieView, displayName: true, displayTitle: true)
                            }
                        case POPULAR:
                            ForEach(viewModel.movies) { movie in
                                MovieCardView(movie: movie)
                                    .onAppear(){
                                        viewModel.loadMoreContent(currentItem: movie, apiRequestType: .popular)
                                    }
                            }
                        case UPCOMING:
                            ForEach(viewModel.movies) { movie in
                                MovieCardView(movie: movie)
                                    .onAppear(){
                                        viewModel.loadMoreContent(currentItem: movie, apiRequestType: .upcoming)
                                    }
                            }
                            
                        default:
                            ForEach(friendsReviews) { review in
                                ReviewCard(review: review, currentMovie: $currentMovie, showMovieView: $showMovieView, displayName: true, displayTitle: true)
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
                            MovieViewController(movie: currentMovie, showMovieView: $showMovieView)
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
 
