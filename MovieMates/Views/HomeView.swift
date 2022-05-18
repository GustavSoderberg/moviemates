//
//  HomeView.swift
//  MovieMates
//
//  Created by Gustav Söderberg on 2022-05-02.
//

import SwiftUI

struct HomeView: View {
    
    @State var index = "friends"
    @State var presentMovie: Movie? = nil
    @State var showMovieView = false
    
    @ObservedObject var viewModel = MovieListViewModel()
    @ObservedObject var allReviewsViewModel = ReviewListViewModel()
    @ObservedObject var friendsReviewsViewModel = ReviewListViewModel()
    
    
    var body: some View {
        ZStack{
            Color("background")
                .ignoresSafeArea()
            
            VStack{
                Picker(selection: $index, label: Text("Review List"), content: {
                    Text("Friends").tag("friends")
                    Text("Trending").tag("trending")
                    Text("Popular").tag("popular")
                    
                })
                .padding(.horizontal)
                .padding(.top, 20)
                .pickerStyle(SegmentedPickerStyle())
                .colorMultiply(.red)
                
                ScrollView{
                    LazyVStack{
                        switch index {
                        case "friends":
                            ForEach(friendsReviewsViewModel.reviews) { review in
                                ReviewCardView(review: review, movieFS: rm.getMovieFS(movieId: "\(review.movieId)"), presentMovie: $presentMovie, showMovieView: $showMovieView)
                            }
                        case "trending":
                            ForEach(allReviewsViewModel.reviews) { review in
                                ReviewCardView(review: review, movieFS: rm.getMovieFS(movieId: "\(review.movieId)"), presentMovie: $presentMovie, showMovieView: $showMovieView)
                            }
                        case "popular":
                            ForEach(viewModel.popularMovies) { movie in
                                MovieCardView(movie: movie)
                            }
                            
                        default:
                            ForEach(friendsReviews) { review in
                                ReviewCardView(review: review, presentMovie: $presentMovie, showMovieView: $showMovieView)
                            }
                        }
                    }
                    .padding()
                    .onAppear {
                        viewModel.fetchPopularMovies()
                    }
                    .sheet(isPresented: $showMovieView) {
                        if let presentMovie = presentMovie {
                            MovieViewController(movie: presentMovie, showMovieView: $showMovieView)
                                .preferredColorScheme(.dark)
                        }
                    }
                }
            }
        }.onChange(of: rm.listOfMovieFS, perform: { newValue in
            allReviewsViewModel.getAllReviews()
            friendsReviewsViewModel.getFriendsReviews()
        })
//        .onAppear {
//            allReviewsViewModel.getAllReviews()
//            friendsReviewsViewModel.getFriendsReviews()
//        }
    }
}

struct ReviewCardView: View {
    
    let review: Review
    var movieFS: MovieFS?
    @State var movie: Movie?
    @Binding var presentMovie: Movie?
    @Binding var showMovieView : Bool
    
    @State private var isExpanded: Bool = false
    
    private let apiService: MovieViewModel = MovieViewModel.shared
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(.gray)
            HStack(alignment: .top){
                if let movie = movieFS {
                    
                    AsyncImage(url: movie.photoUrl){ image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 100, height: 150, alignment: .center)
                    .border(Color.black, width: 3)
                    .onTapGesture {
                        um.refresh += 1
                        print("click!")
                        //presentMovie = movie
                        showMovieView = true
                    }
                    
                    VStack(alignment: .leading){
                        
                        HStack{
                            Text(um.getUser(id: review.authorId).username)
                            Spacer()
                            Text(formatDate(date: review.timestamp))
                                .font(.system(size: 12))
                        }
                        
                        Text(movie.title)
                            .font(.title2)
                            .minimumScaleFactor(0.7)
                            .lineLimit(1)
                        
                        Text("\(review.rating)")
                            .padding(.bottom, 4)
                        
                        Text(review.reviewText)
                            .font(.system(size: 15))
                            .lineLimit(isExpanded ? nil : 4)
                            .onTapGesture {
                                isExpanded.toggle()
                            }
                    }
                }
            }
            .padding()
        }
    }
}

func formatDate(date: Date) -> String{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "d MMMM yyyy"
    return dateFormatter.string(from: date)
}


private var friendsReviews = [Review
//    Review(movieId: 10612, username: "Sarah", title: "The Batman", rating: "5/5", reviewText: "Siken film! jag grät, jag skrek, jag belv en helt ny människa!"),
//    Review(movieId: 634649, username: "Oscar", title: "The Duckman", rating: "4/5", reviewText: "Jag gillar ankor så denna film var helt perfekt för mig! Dock så var det ett himla kvackande i biosalongen."),
//    Review(movieId: 364, username: "Joakim", title: "The Birdman", rating: "1/5", reviewText: "Trodde filmen skulle handla om en fågel som ville bli människa, men det var ju helt fel! Den handlar om en man som trodde han var en fågel. Falsk marknadsföring!"),
//    Review(movieId: 414, username: "Gustav", title: "The Spiderman", rating: "5/5", reviewText: "Jag somnade efter 30min och vaknade strax innan slutet. Bästa tuppluren jag haft på länge! Rekomenderas starkt!")
]()

private var trendingReviews = [Review
//    Review(movieId: 414906, username: "Oscar", title: "The Duckman", rating: "4/5", reviewText: "Jag gillar ankor så denna film var helt perfekt för mig! Dock så var det ett himla kvackande i biosalongen."),
//    Review(movieId: 284052, username: "Joakim", title: "The Birdman", rating: "1/5", reviewText: "Trodde filmen skulle handla om en fågel som ville bli människa, men det var ju helt fel! Den handlar om en man som trodde han var en fågel. Falsk marknadsföring!"),
//    Review(movieId: 406759, username: "Gustav", title: "The Spiderman", rating: "5/5", reviewText: "Jag somnade efter 30min och vaknade strax innan slutet. Bästa tuppluren jag haft på länge! Rekomenderas starkt!"),
//    Review(movieId: 414906, username: "Sarah", title: "The Batman", rating: "5/5", reviewText: "Siken film! jag grät, jag skrek, jag belv en helt ny människa!")
]()

//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
//}
