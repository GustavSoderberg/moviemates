//
//  MovieView.swift
//  MovieMates
//
//  Created by Oscar Karlsson on 2022-05-03.
//

import SwiftUI
import Alamofire
import UIKit

enum Sheet {
    case MovieView, ReviewSheet
}

struct MovieViewController: View {
    @State var sheetShowing: Sheet = .MovieView
    @State var movie: Movie
    @Binding var showMovieView: Bool
    
    var body: some View {
        
        VStack {
            switch self.sheetShowing {
                
            case .MovieView:
                MovieView(sheetShowing: $sheetShowing, currentMovie: $movie, showMovieView: $showMovieView)
                
            case .ReviewSheet:
                ReviewSheet(sheetShowing: $sheetShowing, currentMovie: $movie)
            }
        }
        .interactiveDismissDisabled()
    }
}

struct MovieView: View {
    @Binding var sheetShowing: Sheet
    @Binding var currentMovie: Movie
    @Binding var showMovieView: Bool
    
    @State var title : String = "Movie Title"
    @State var description : String = "Movie Description"
    @State var poster : Image = Image("bill_poster")
    @State var ratingGlobalWidth : Float = 67
    @State var ratingLocalWidth : Float = 14
    @State var ratingGlobalScore : String = "0"
    @State var ratingLocalScore : String = "0"
    
    @State var onWatchlist = false
    @State var watchlistText  = "Add to Watchlist?"
    
    @State var descFull = false
    @State var descHeight: CGFloat? = 110
    
    @State var index = "friends"
    @State var watchlist = false
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                HStack {
                    Text("Done")
                        .foregroundColor(.clear)
                    VStack{
                        gap(height: 2)
                        Text(title)
                            .font(Font.headline.weight(.bold))
                            .multilineTextAlignment(.center)
                    }
                    Text("Review")
                        .foregroundColor(.clear)
                }
                .padding(.horizontal)
                
                HStack {
                    Text("Done")
                        .foregroundColor(.blue)
                        .onTapGesture {
                            showMovieView = false
                        }
                    Spacer()
                    Text("Review")
                        .foregroundColor(.blue)
                        .onTapGesture {
                            sheetShowing = .ReviewSheet
                        }
                }
                .padding(.horizontal)
            }
            
            gap(height: 5)
            Divider()
            
            ScrollView{
                VStack{
                    AsyncImage(url: currentMovie.backdropURL) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: .infinity, height: 220, alignment: .center)
                    
                    Text(description)
                        .onTapGesture {
                            if descFull {
                                descFull = false
                                descHeight = .infinity
                            } else {
                                descFull = true
                                descHeight = 110
                            }
                        }
                        .frame(maxHeight: descHeight)
                }
                .padding(.horizontal)
                
                HStack {
                    Spacer()
                    Text("\(watchlistText)")
                        .padding(.horizontal)
                        .background(.gray)
                        .cornerRadius(5)
                        .foregroundColor(.white)
                        .font(Font.headline.weight(.bold))
                        .onTapGesture {
                            //TODO ad to wishlist
                            if onWatchlist {
                                onWatchlist = false
                                watchlistText = "Add to Watchlist?"
                            } else {
                                onWatchlist = true
                                watchlistText = "On Watchlist"
                            }
                        }
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.vertical, -3)
                
                VStack(spacing:0){
                    ZStack{
                        Rectangle()
                            .cornerRadius(15)
                            .padding(.horizontal)
                            .frame(height: 90)
                            .foregroundColor(.gray)
                        
                        VStack(spacing:0) {
                            HStack{
                                Text("RATINGS")
                                    .font(Font.headline.weight(.bold))
                                    .foregroundColor(.white)
                                Spacer()
                            }
                            .padding(.horizontal)
                            .padding(.leading, 12)
                            
                            Divider()
                                .padding(.horizontal)
                            
                            gap(height: 5)
                            
                            HStack{
                                Text("GLOBAL")
                                    .foregroundColor(.white)
                                Spacer()
                                HStack(spacing: 2) {
                                    ForEach(1..<6) { i in
                                        ReviewClapper(pos: i, score: $ratingGlobalScore)
                                    }
                                }
                                .frame(height: 20)
                                
                                Text("\(ratingGlobalScore)")
                                    .foregroundColor(.white)
                                    .frame(maxWidth: 30, alignment: .leading)
                                Spacer()
                            }
                            .padding(.horizontal, 30.0)
                            
                            gap(height: 5)
                            
                            HStack{
                                Text("FRIENDS")
                                    .foregroundColor(.white)
                                Spacer()
                                HStack(spacing: 2) {
                                    ForEach(1..<6) { i in
                                        ReviewClapper(pos: i, score: $ratingLocalScore)
                                    }
                                }
                                .frame(height: 20)
                                
                                Text("\(ratingLocalScore)")
                                    .foregroundColor(.white)
                                    .frame(maxWidth: 30, alignment: .leading)
                                Spacer()
                            }
                            .padding(.horizontal, 30.0)
                        }
                    }
                }
                
                Divider()
                
                VStack(spacing:0){
                    ZStack{
                        VStack(spacing: 0){
                            HStack{
                                Text("REVIEWS")
                                    .font(Font.headline.weight(.bold))
                                    //.foregroundColor(.white)
                                Spacer()
                            }
                            .padding(.horizontal)
                            .padding(.leading, 12)
                            
                            
                            
                            Picker(selection: $index, label: Text("Review List"), content: {
                                Text("Friends").tag("friends")
                                Text("Global").tag("global")
                            })
                            .padding(.horizontal, 14)
                            .pickerStyle(SegmentedPickerStyle())
                            .colorMultiply(.red)
                        }
                
                    }
                    
                    gap(height: 5)
                    
                    LazyVStack(spacing: 2) {
                        switch index {
                        case "friends":
                            ForEach(friendsReviews) { review in
                                MovieReviewCardView(review: review)
                            }
                        case "global":
                            ForEach(globalReviews) { review in
                                MovieReviewCardView(review: review)
                            }
                            
                        default:
                            ForEach(friendsReviews) { review in
                                MovieReviewCardView(review: review)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            
        }
        .onAppear(perform: {
            title = currentMovie.title ?? "Title"
            description = currentMovie.overview ?? "Description"
            //Search for "O", think it's the third movie
            if description == "" {
                description = "No further description"
            }
            
            ratingGlobalWidth = Float(Int.random(in: 1...100))
            ratingLocalWidth = Float(Int.random(in: 1...100))
            ratingGlobalScore = String(format: "%.1f", ratingGlobalWidth/20)
            if ratingGlobalScore.hasSuffix("0") {
                ratingGlobalScore = String(ratingGlobalScore.prefix(1))
            }
            
            ratingLocalScore = String(format: "%.1f", ratingLocalWidth/20)
            if ratingLocalScore.hasSuffix("0") {
                ratingLocalScore = String(ratingLocalScore.prefix(1))
            }
        })
    }
}


struct ReviewClapper: View {
    var pos : Int
    @Binding var score : String
    @State var width : Float = 20
    
    var body: some View {
        GeometryReader { geo in
            Rectangle()
                .frame(width: 20, height: 20)
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.white)
            
            Rectangle()
                .frame(width: CGFloat(width), height: 20)
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.black)
            
            Image("clapper_hollow")
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundColor(.gray)
        }
        .frame(width: 20, height: 20)
        .onAppear(perform: {
            if Int(score.prefix(1)) ?? 0 >= pos {
                width = 20
            } else if ((Int(score.prefix(1)) ?? 0) + 1) == pos {
                width = ((Float(score.prefix(3)) ?? 0) - (Float(score.prefix(1)) ?? 0))*20
            } else {
                width = 0
            }
            //print("pos: \(pos), score: \(score), width: \(width)")
        })
    }
}

struct ClapperImage: View {
    var pos : Int
    var score : String
    @State var filled : Bool = false
    
    var body: some View {
        Image("clapper-big")
            .resizable()
            .frame(width: 20, height: 20)
            .foregroundColor(filled ? .black : .white)
            .onAppear(perform: {
                if Int(score.prefix(1)) ?? 0 >= pos {
                    filled = true
                } else {
                    filled = false
                }
            })
    }
}

private var friendsReviews = [
    Review(movieId: 414906, username: "Sarah", title: "The Batman", rating: "5/5", reviewText: "Siken film! jag grät, jag skrek, jag belv en helt ny människa!"),
    Review(movieId: 272, username: "Oscar", title: "The Duckman", rating: "4/5", reviewText: "Jag gillar ankor så denna film var helt perfekt för mig! Dock så var det ett himla kvackande i biosalongen."),
    Review(movieId: 364, username: "Joakim", title: "The Birdman", rating: "1/5", reviewText: "Trodde filmen skulle handla om en fågel som ville bli människa, men det var ju helt fel! Den handlar om en man som trodde han var en fågel. Falsk marknadsföring!"),
    Review(movieId: 414, username: "Gustav", title: "The Spiderman", rating: "5/5", reviewText: "Jag somnade efter 30min och vaknade strax innan slutet. Bästa tuppluren jag haft på länge! Rekomenderas starkt!")
]

private var globalReviews = [
    Review(movieId: 414, username: "Rikard", title: "The Spiderman", rating: "2/5", reviewText: "meh."),
    Review(movieId: 414, username: "Rakel", title: "The Spiderman", rating: "5/5", reviewText: "Detta var en bra film!"),
    Review(movieId: 414, username: "Gunnar", title: "The Spiderman", rating: "1/5", reviewText: "Vad var detta?"),
    Review(movieId: 414, username: "Örjan", title: "The Spiderman", rating: "3/5", reviewText: "varken bra eller dålig"),
    Review(movieId: 414, username: "Björn", title: "The Spiderman", rating: "2/5", reviewText: "")
]

struct MovieReviewCardView: View {
    
    let review: Review
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(.gray)
            HStack(alignment: .top){
                VStack(alignment: .leading){
                    HStack{
                        Text(review.username)
                        Spacer()
                        Text(formatDate(date: review.timestamp))
                            .font(.system(size: 12))
                    }
                    HStack{
                        ForEach(1..<6) { i in
                            ClapperImage(pos: i, score: review.rating)
                        }
                        Spacer()
                    }
                    Text(review.reviewText)
                        .font(.system(size: 15))
                        .lineLimit(3)
                    Spacer()
                }
            }
            .padding()
        }
    }
}

struct gap :View {
    var height: CGFloat?
    var body: some View {
        Rectangle()
            .frame(height: height)
            .foregroundColor(.clear)
    }
}

struct line :View {
    var color: Color?
    var body: some View {
        Rectangle()
            .frame(height: 1)
            .foregroundColor(color)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {
    
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}



//Preview!!
struct MovieView_Previews: PreviewProvider {
    static var previews: some View {
        MovieViewController(movie: Movie(id: 1, adult: nil, backdropPath: "/f53Jujiap580mgfefID0T0g2e17.jpg", genreIDS: nil, originalLanguage: nil, originalTitle: nil, overview: "Poe Dameron and BB-8 must face the greedy crime boss Graballa the Hutt, who has purchased Darth Vader’s castle and is renovating it into the galaxy’s first all-inclusive Sith-inspired luxury hotel.", releaseDate: nil, posterPath: "/fYiaBZDjyXjvlY6EDZMAxIhBO1I.jpg", popularity: nil, title: "LEGO Star Wars Terrifying Tales", video: nil, voteAverage: nil, voteCount: nil), showMovieView: .constant(true))
    }
}

