//
//  HomeView.swift
//  MovieMates
//
//  Created by Gustav Söderberg on 2022-05-02.
//

/**
 - Description: In this view we have three tabs. The first is for the profileView where information is about the current user. Second is the homeView where we have three tabs. Here we can find reviews that friends have made but also a tab where reviews from the whole app can be shown. The third tab is searchView, where we can search for a movie/serie and a user.
 
 */

import SwiftUI

struct HomeView: View {
    @AppStorage("darkmode") private var darkmode = true
    @EnvironmentObject var statusController: StatusController
    
    @State var index = "trending"
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
            
            VStack{
                Picker(selection: $index, label: Text("Review List"), content: {
                    Text("Friends").tag(FRIENDS)
                    Text("Trending").tag(TRENDING)
                    Text("Discover").tag(DISCOVER)
                    
                })
                .padding(.horizontal)
                .padding(.top, 20)
                .pickerStyle(SegmentedPickerStyle())
                .colorMultiply(Color("accent-color"))
                
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
                                        .background(LinearGradient(gradient: Gradient(colors: [Color("welcome-clapper-top"), Color("welcome-clapper-bottom")]), startPoint: .top, endPoint: .bottom)
                                            .mask(Rectangle()
                                                .cornerRadius(5))
                                                .shadow(radius: 6))
                                        .foregroundColor(darkmode ? .white : .black)
                                }
//                                Button {
//                                    statusController.searchIndex = "users"
//                                    statusController.selection = 3
//                                } label: {
//                                    Text("Search Users")
//                                }

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
                                if reviews.count == 1 {
                                    ReviewCard(review: reviews[0], movieFS: rm.getMovieFS(movieId: "\(reviews[0].movieId)"), currentMovie: $currentMovie, showMovieView: $showMovieView, userProfile: $userProfile, showProfileView: $showProfileView, displayName: true, displayTitle: true, blurSpoiler: !rm.dismissedSpoiler.contains(reviews[0].id))
                                } else {
                                    GroupHeader(reviews: reviews, currentMovie: $currentMovie, showMovieView: $showMovieView, userProfile: $userProfile, showProfileView: $showProfileView, blurSpoiler: true)
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
            statusController.searchIndex = "movies"
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
