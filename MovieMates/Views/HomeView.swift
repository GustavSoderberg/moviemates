//
//  HomeView.swift
//  MovieMates
//
//  Created by Gustav Söderberg on 2022-05-02.
//

import SwiftUI

struct HomeView: View {
    
    @State var index = "friends"
    @State var showMovieView = false
    
    var body: some View {
        ZStack{
            Color("background")
                .ignoresSafeArea()
            
            VStack{
                Picker(selection: $index, label: Text("Review List"), content: {
                    Text("Friends").tag("friends")
                    Text("Trending").tag("trending")
                    
                })
                    .padding(.horizontal)
                    .padding(.top, 20)
                    .pickerStyle(SegmentedPickerStyle())
                    .colorMultiply(.red)
                
                ScrollView{
                    LazyVStack{
                        switch index {
                        case "friends":
                            ForEach(friendsReviews) { review in
                                ReviewCardView(review: review, showMovieView: $showMovieView)
                            }
                        case "trending":
                            ForEach(trendingReviews) { review in
                                ReviewCardView(review: review, showMovieView: $showMovieView)
                            }
                            
                        default:
                            ForEach(friendsReviews) { review in
                                ReviewCardView(review: review, showMovieView: $showMovieView)
                            }
                        }
                    }.padding()
                }
                //TODO: The sheet needs darkmode/lightmode specified based on the device colorScheme
                .sheet(isPresented: $showMovieView) {
                    MovieViewController()
                        .preferredColorScheme(.dark)
//                        .preferredColorScheme( true ? .dark : .light)
                }
            }
        }
    }
}

struct ReviewCardView: View {
    
    let review: Review
    @State var movie: Movie?
    @Binding var showMovieView : Bool
    
    private let apiService: MovieViewModel = MovieViewModel.shared
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(.gray)
            HStack(alignment: .top){
                if let movie = movie {
                    AsyncImage(url: movie.posterURL){ image in
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
                        showMovieView = true
                    }
                    
                    VStack(alignment: .leading){
                        
                        HStack{
                            Text(review.username)
                            Spacer()
                            Text(formatDate(date: review.timestamp))
                                .font(.system(size: 12))
                        }
                        Text(movie.title ?? "no title")
                            .font(.title2)
                        Text(review.rating)
                        Spacer()
                        Text(review.reviewText)
                            .font(.system(size: 15))
                            .lineLimit(3)
                        Spacer()
                    }
                }
            }
            .padding()
        }.onAppear {
            loadMovie(id: review.movieId)
        }
    }
    
    func loadMovie(id: Int){
        apiService.fetchMovie(id: id) { result in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let movie):
                    self.movie = movie
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


private var friendsReviews = [
    Review(movieId: 414906, username: "Sarah", title: "The Batman", rating: "5/5", reviewText: "Siken film! jag grät, jag skrek, jag belv en helt ny människa!"),
    Review(movieId: 272, username: "Oscar", title: "The Duckman", rating: "4/5", reviewText: "Jag gillar ankor så denna film var helt perfekt för mig! Dock så var det ett himla kvackande i biosalongen."),
    Review(movieId: 364, username: "Joakim", title: "The Birdman", rating: "1/5", reviewText: "Trodde filmen skulle handla om en fågel som ville bli människa, men det var ju helt fel! Den handlar om en man som trodde han var en fågel. Falsk marknadsföring!"),
    Review(movieId: 414, username: "Gustav", title: "The Spiderman", rating: "5/5", reviewText: "Jag somnade efter 30min och vaknade strax innan slutet. Bästa tuppluren jag haft på länge! Rekomenderas starkt!")
]

private var trendingReviews = [
    Review(movieId: 414906, username: "Oscar", title: "The Duckman", rating: "4/5", reviewText: "Jag gillar ankor så denna film var helt perfekt för mig! Dock så var det ett himla kvackande i biosalongen."),
    Review(movieId: 284052, username: "Joakim", title: "The Birdman", rating: "1/5", reviewText: "Trodde filmen skulle handla om en fågel som ville bli människa, men det var ju helt fel! Den handlar om en man som trodde han var en fågel. Falsk marknadsföring!"),
    Review(movieId: 406759, username: "Gustav", title: "The Spiderman", rating: "5/5", reviewText: "Jag somnade efter 30min och vaknade strax innan slutet. Bästa tuppluren jag haft på länge! Rekomenderas starkt!"),
    Review(movieId: 414906, username: "Sarah", title: "The Batman", rating: "5/5", reviewText: "Siken film! jag grät, jag skrek, jag belv en helt ny människa!")
]

//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
//}
