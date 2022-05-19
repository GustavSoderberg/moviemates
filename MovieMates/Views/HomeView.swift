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
    @State var presentMovie: Movie? = nil
    
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
                                ReviewCardView(review: review, movieFS: rm.getMovieFS(movieId: "\(review.movieId)"), presentMovie: $presentMovie, showMovieView: $showMovieView)
                            }
                        case TRENDING:
                            ForEach(allReviewsViewModel.reviews) { review in
                                ReviewCardView(review: review, movieFS: rm.getMovieFS(movieId: "\(review.movieId)"), presentMovie: $presentMovie, showMovieView: $showMovieView)
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
                                ReviewCardView(review: review, presentMovie: $presentMovie, showMovieView: $showMovieView)
                            }
                        }
                    }
//                    .onAppear {
//                        viewModel.clearList()
//                        viewModel.requestMovies(apiReuestType: .popular)
//                    }
                    .padding()
                    .sheet(isPresented: $showMovieView) {
                        if let presentMovie = presentMovie {
                            MovieViewController(movie: presentMovie, showMovieView: $showMovieView)
                                .preferredColorScheme(darkmode ? .dark : .light)
                        }
                    }
                }

            }
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

struct ReviewCardView: View {
    
    let review: Review
    var movieFS: MovieFS?
    @Binding var presentMovie: Movie?
    @Binding var showMovieView : Bool
    
    @State private var isExpanded: Bool = false
    
    private let movieViewModel: MovieViewModel = MovieViewModel.shared
    
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
                        
                        print("click!")
                        loadMovie(id: movie.id!)
                        showMovieView = true
                        //um.refresh += 1
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
    func loadMovie(id: String) {
        presentMovie = nil
        movieViewModel.fetchMovie(id: Int(id)!) { result in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let movie):
                    presentMovie = movie
                }
            }
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
