/**
 - Description:
    In this View we get the chosen movie that we picked. In here we get the description of the current movie and reviews from the tab "global" and "friends".
    We can also add a movie to our watchlist that you can find on you profileView.
 
 - Authors:
    Karol Ö
    Oscar K
    Sarah L
    Joakim A
    Denis R
    Gustav S
 
 */


import SwiftUI
import Alamofire
import UIKit

enum Sheet {
    case MovieView, ReviewSheet
}

struct MovieViewController: View {
    
    @State var sheetShowing: Sheet = .MovieView
    @State var movie: Movie
    @State var movieFS: MovieFS?
    @State var isUpcoming: Bool
    
    @Binding var showMovieView: Bool
    
    var body: some View {
        
        VStack {
            switch self.sheetShowing {
                
            case .MovieView:
                MovieView(sheetShowing: $sheetShowing, currentMovie: $movie, showMovieView: $showMovieView, movieFS: $movieFS, isUpcoming: $isUpcoming)
                
            case .ReviewSheet:
                ReviewSheet(sheetShowing: $sheetShowing, currentMovie: $movie)
            }
        }
        .interactiveDismissDisabled()
        .onAppear {
            if rm.checkIfMovieExists(movieId: "\(movie.id)") {
                movieFS = rm.getMovieFS(movieId: "\(movie.id)")
            }
        }
    }
}

struct MovieView: View {
    @AppStorage(DARKMODE) private var darkmode = true
    @ObservedObject var orm = rm
    
    @Binding var sheetShowing: Sheet
    @Binding var currentMovie: Movie
    @Binding var showMovieView: Bool
    @Binding var movieFS: MovieFS?
    @Binding var isUpcoming: Bool
    
    @State var userProfile: User? = nil
    @State var showProfileView = false
    
    @State var friendsReviews = [Review]()
    
    @State var title : String = "Movie Title"
    @State var description : String = "Movie Description"
    @State var ratingGlobalScore : String = "0"
    @State var ratingLocalScore : String = "0"
    
    @State var onWatchlist = false
    @State var watchlistText  = "Add to Watchlist?"
    
    @State var descFull = false
    @State var descHeight: CGFloat? = 110
    
    @State var index = FRIENDS
    @State var watchlist = false
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                HStack {
                    Text("Close")
                        .foregroundColor(.clear)
                    VStack{
                        gap(height: 2)
                        Text(title)
                            .font(Font.headline.weight(.bold))
                            .multilineTextAlignment(.center)
                    }
                    
                    Text("Close")
                        .foregroundColor(.clear)
                }
                .padding(.horizontal)
                
                HStack {
                    Text("Close")
                        .foregroundColor(.blue)
                        .onTapGesture {
                            showMovieView = false
                        }
                    Spacer()
                }
                .padding(.horizontal)
            }
            
            gap(height: 5)
            Divider()
            
            ScrollView {
                VStack(spacing: 0) {
                    AsyncImage(url: currentMovie.backdropURL) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: .infinity, height: 220, alignment: .center)
                    
                    HStack(spacing: 15){
                        Text(currentMovie.releaseDate!.prefix(4))
                            .background(RoundedRectangle(cornerRadius: 5)
                                .foregroundColor(.black)
                                .opacity(darkmode ? 1 : 0.2)
                                .padding(.horizontal, -5))
                            .font(Font.system(size: 15).italic())
                            .opacity(0.7)
                            
                        Spacer()
                    }
                    .padding(.top, 2)
                    
                    Text(description)
                        .onTapGesture {
                            withAnimation() {
                                if !descFull {
                                    descFull = true
                                    descHeight = .infinity
                                } else {
                                    descFull = false
                                    descHeight = 110
                                }
                            }
                        }
                        .frame(maxHeight: descHeight)
                }
                .padding(.horizontal)
                .frame(width: UIScreen.main.bounds.size.width)
                
                HStack {
                    Button {
                        if !onWatchlist {
                            watchlistText = "On Watchlist"
                            um.addToWatchlist(movieID: "\(currentMovie.id)")
                            onWatchlist = true
                        } else {
                            watchlistText = "Add to Watchlist"
                            um.removeMovieWatchlist(movieID: "\(currentMovie.id)")
                            onWatchlist =  false
                        }
                    } label: {
                        Text("\(watchlistText)")
                            .padding(.horizontal)
                            .padding(.vertical, 4)
                            .cornerRadius(5)
                            .font(Font.headline.weight(.bold))
                            .font(.system(size: 15))
                            .background(LinearGradient(gradient: Gradient(colors: onWatchlist ? [Color("welcome-clapper-top"), Color("welcome-clapper-bottom")] : [.gray, Color("secondary-background")]), startPoint: .top, endPoint: .bottom)
                                .mask(Rectangle()
                                    .cornerRadius(5))
                                    .shadow(radius: 10))
                            .foregroundColor(darkmode ? .white : .black)
                    }
                    .onAppear {
                        onWatchlist = um.currentUser!.watchlist.contains("\(currentMovie.id)") ? true : false
                        watchlistText = um.currentUser!.watchlist.contains("\(currentMovie.id)") ? "On Watchlist" : "Add to Watchlist"
                    }
                    
                    if isUpcoming != true {
                        Button {
                            withAnimation(.easeIn(duration: 0.3)){
                                sheetShowing = .ReviewSheet
                            }
                        } label: {
                            Text("Review")
                                .padding(.horizontal)
                                .padding(.vertical, 4)
                                .cornerRadius(5)
                                .font(Font.headline.weight(.bold))
                                .font(.system(size: 15))
                                .background(LinearGradient(gradient: Gradient(colors: [Color(GRADIENT_TOP), Color(GRADIENT_BOTTOM)]), startPoint: .top, endPoint: .bottom)
                                    .mask(Rectangle()
                                        .cornerRadius(5))
                                        .shadow(radius: 10))
                                .foregroundColor(darkmode ? .white : .black)
                        }
                    }
                }
                .padding(.horizontal)
                
                VStack(spacing:0){
                    ZStack{
                        Rectangle()
                            .cornerRadius(15, corners: [.topLeft, .topRight])
                            .frame(height: 30)
                            .foregroundColor(Color(BACKGROUND_2))
                        
                        VStack(spacing:0) {
                            
                            HStack{
                                Text("RATINGS")
                                    .font(Font.headline.weight(.bold))
                                Spacer()
                            }
                            .padding(.horizontal)
                            .padding(.leading, 12)
                        }
                    }
                    
                    Divider()
                    
                    ZStack{
                        LinearGradient(gradient: Gradient(colors: [Color(BACKGROUND_2) , .gray]), startPoint: .top, endPoint: .bottom)
                            .mask(Rectangle()
                                .cornerRadius(15, corners: [.bottomLeft, .bottomRight])
                                .frame(height: 70))
                            .shadow(radius: 10)
                        
                        VStack(spacing: 0) {
                            
                            gap(height: 5)
                            
                            HStack{
                                Spacer()
                                HStack{
                                    Text("GLOBAL")
                                        .font(Font.headline.weight(.bold))
                                    Image(systemName: "globe.europe.africa")
                                        .font(.system(size: 20))
                                }
                                .frame(width: 110, alignment: .leading)
                                Spacer()
                                ZStack(alignment: .center) {
                                    RoundedRectangle(cornerRadius: 5)
                                        .frame(width: 115, height: 25)
                                        .foregroundColor(Color(BACKGROUND_2))
                                    
                                    HStack(spacing: 2) {
                                        if orm.cacheGlobal != orm.getAverageRating(movieId: currentMovie.id, onlyFriends: false) {
                                            
                                            ForEach(1..<6) { i in
                                                ReviewClapper(pos: i, score: "\(orm.getAverageRating(movieId: currentMovie.id, onlyFriends: false))", movieId: currentMovie.id, gray: true)
                                            }
                                            .onAppear {
                                                orm.cacheGlobal = 0
                                            }
                                        } else {
                                            
                                            ForEach(1..<6) { i in
                                                ReviewClapper(pos: i, score: "\(orm.getAverageRating(movieId: currentMovie.id, onlyFriends: false))", movieId: currentMovie.id, gray: true)
                                            }
                                        }
                                    }
                                    .frame(height: 20)
                                }
                                
                                Text("\(ratingGlobalScore)")
                                    .frame(maxWidth: 30, alignment: .leading)
                                    .font(Font.headline.weight(.bold))
                                    .font(.system(size: 20))
                                Spacer()
                            }
                            .padding(.horizontal)
                            
                            gap(height: 5)
                        
                            HStack{
                                Spacer()
                                HStack{
                                    Text("FRIENDS")
                                        .font(Font.headline.weight(.bold))
                                    Image(systemName: "person.2.circle")
                                        .font(.system(size: 20))
                                }
                                .frame(width: 110, alignment: .leading)
                                Spacer()
                                ZStack(alignment: .center) {
                                    RoundedRectangle(cornerRadius: 5)
                                        .frame(width: 115, height: 25)
                                        .foregroundColor(Color(BACKGROUND_2))
                                    
                                    HStack(spacing: 2) {
                                        if orm.cacheFriends != orm.getAverageRating(movieId: currentMovie.id, onlyFriends: true) {
                                            ForEach(1..<6) { i in
                                                ReviewClapper(pos: i, score: "\(orm.getAverageRating(movieId: currentMovie.id, onlyFriends: true))", movieId: currentMovie.id, gray: true)
                                            }
                                        } else {
                                            ForEach(1..<6) { i in
                                                ReviewClapper(pos: i, score: "\(orm.getAverageRating(movieId: currentMovie.id, onlyFriends: true))", movieId: currentMovie.id, gray: true)
                                            }
                                        }
                                    }
                                    .frame(height: 20)
                                }
                                
                                Text("\(ratingLocalScore)")
                                    .frame(maxWidth: 30, alignment: .leading)
                                    .font(Font.headline.weight(.bold))
                                    .font(.system(size: 20))
                                Spacer()
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.horizontal)
                
                Divider()
                
                VStack(spacing:0){
                    ZStack{
                        VStack(spacing: 0){
                            HStack{
                                Text("REVIEWS")
                                    .font(Font.headline.weight(.bold))
                                Spacer()
                            }
                            .padding(.horizontal)
                            .padding(.leading, 12)
                            
                            Picker(selection: $index, label: Text("Review List"), content: {
                                Text("Friends").tag(FRIENDS)
                                Text("Global").tag(GLOBAL)
                            })
                            .padding(.horizontal, 14)
                            .pickerStyle(SegmentedPickerStyle())
                            .colorMultiply(Color(BACKGROUND_2))
                        }
                    }
                    
                    gap(height: 5)
                    
                    LazyVStack(spacing: 2) {
                        switch index {
                        case FRIENDS:
                            if movieFS != nil {
                                ForEach(rm.getMovieReviews(movieId: currentMovie.id, onlyFriends: true, includeSelf: false)) { review in
                                    ReviewCard(review: review, currentMovie: .constant(nil), showMovieView: .constant(true), userProfile: $userProfile, showProfileView: $showProfileView, displayName: true, displayTitle: false, blurSpoiler: false)
                                }
                            } else {
                                Text("No Reviews")
                            }
                            
                        case GLOBAL:
                            if movieFS != nil {
                                ForEach(rm.getMovieReviews(movieId: currentMovie.id, onlyFriends: false, includeSelf: false)) { review in
                                    ReviewCard(review: review, currentMovie: .constant(nil), showMovieView: .constant(true), userProfile: $userProfile, showProfileView: $showProfileView, displayName: true, displayTitle: false, blurSpoiler: false)
                                }
                            } else {
                                Text("No Reviews")
                            }
                            
                        default:
                            ForEach(friendsReviews) { review in
                                ReviewCard(review: review, currentMovie: .constant(nil), showMovieView: .constant(true), userProfile: $userProfile, showProfileView: $showProfileView, displayName: true, displayTitle: false, blurSpoiler: false)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .onAppear {
                        
                        if let movieFS = movieFS {
                            friendsReviews = rm.getMovieReviews(movieId: Int(movieFS.id!)!, onlyFriends: true, includeSelf: false)
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showProfileView) {
            if let userProfile = userProfile {
                ProfileView(user: userProfile)
                    .preferredColorScheme(darkmode ? .dark : .light)
            } else {
                Text("NIL")
            }
            
        }
        .onAppear(perform: {
            title = currentMovie.title ?? "Title"
            description = currentMovie.overview ?? "Description"
            if description == "" {
                description = "No further description"
            }
            
            ratingGlobalScore = "\(movieFS?.rating ?? 0.0)"
            ratingGlobalScore = String(ratingGlobalScore.prefix(3))
            ratingLocalScore = "\(rm.getAverageRating(movieId: currentMovie.id, onlyFriends: true))"
            ratingLocalScore = String(ratingLocalScore.prefix(3))
            ratingLocalScore = ratingLocalScore == "nan" ? "-" : ratingLocalScore
            
            if ratingGlobalScore.hasSuffix("0") {
                ratingGlobalScore = String(ratingGlobalScore.prefix(1))
            }
            
            if ratingLocalScore.hasSuffix("0") {
                ratingLocalScore = String(ratingLocalScore.prefix(1))
            }
        })
    }
}

/**
 - Description: This view draws our clappers and sets the score.
 */
struct ReviewClapper: View {
    var pos : Int
    @State var score : String
    @State var width : Float = 20
    @State var movieId: Int
    let gray: Bool
    
    var body: some View {
        GeometryReader { geo in
            Rectangle()
                .frame(width: 20, height: 20)
                .aspectRatio(contentMode: .fit)
                .foregroundColor(gray ? .black : Color(CLAPPER_SHADOW))
                .opacity(gray ? 0.2 : 1)
            
            Rectangle()
                .frame(width: CGFloat(width), height: 20)
                .aspectRatio(contentMode: .fit)
                .foregroundColor(Color(BW))
            
            Image(CLAPPER_HOLE)
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundColor(gray ? Color(BACKGROUND_2) : Color(GRADIENT_TOP))
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
            
        })
        .onChange(of: score) { newValue in
            if Int(score.prefix(1)) ?? 0 >= pos {
                width = 20
            } else if ((Int(score.prefix(1)) ?? 0) + 1) == pos {
                width = ((Float(score.prefix(3)) ?? 0) - (Float(score.prefix(1)) ?? 0))*20
            } else {
                width = 0
            }
            rm.cacheGlobal = rm.getAverageRating(movieId: movieId, onlyFriends: false)
            rm.cacheFriends = rm.getAverageRating(movieId: movieId, onlyFriends: true)
            rm.refresh += 1
        }
    }
}
