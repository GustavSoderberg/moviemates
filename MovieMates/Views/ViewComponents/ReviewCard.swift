/**
 
 - Description:
 Where the structs for the visual display of reviews are stored.
 
 - ReviewCard: The foundation for every review, it calls other structs to build a full review card.
 
 - GroupHeader: The foundation for a group of reviews. this includes a poster, the average ratings and then a list of reviews connected to it.
 
 - AverageRatingLine: A line of "clappers" that can be half filled to reprecent a decimal score ex. 3.5 would be 3 filled and one half filled. This is connected to a GroupHeader.
 
 - ReviewCardGrouped: The foundation for a review that is connected to a GroupHeader
 
 - ReviewTopView: Has the information stired at the top of a review. Profile picture, Name of user, Title of Movie etc.
 
 - ReviewTextView: Displayes the text the user has writen.
 
 - ReviewTab: The bottom of a review. A tap displaying where and with who you saw the movie with, also houses the LikeLine.
 
 - LikeLine: Displays the number of likes and a like button in a HStack
 
 - ClapperLine: Makes a line of clappers displaying the rating the user gave the movie.
 
 - ClapperImage: The ClapperLine contains 5 of these.
 
 - Authors:
    Karol Ö
    Oscar K
    Sarah L
    Joakim A
    Denis R
    Gustav S
 
 */

import SwiftUI

struct ReviewCard: View {
    
    @AppStorage("darkmode") private var darkmode = true
    @AppStorage("spoilerCheck") private var spoilerCheck = true
    
    let review: Review
    var movieFS: MovieFS?
    
    
    @Binding var currentMovie: Movie?
    @Binding var showMovieView : Bool
    
    @Binding var userProfile: User?
    @Binding var showProfileView : Bool
    
    let displayName: Bool
    let displayTitle: Bool
    var blurSpoiler: Bool
    
    private let movieViewModel: MovieViewModel = MovieViewModel.shared
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color(GRADIENT_TOP) , Color(GRADIENT_BOTTOM)]), startPoint: .top, endPoint: .bottom)
                .mask(RoundedRectangle(cornerRadius: 25, style: .continuous))
                .shadow(radius: 10)
                .onTapGesture {
                    loadMovie(id: String(review.movieId))
                    showMovieView = true
                }
            
            VStack(spacing: 0) {
                ReviewTopView(review: review, showProfileView: $showProfileView, userProfile: $userProfile, displayName: displayName, displayTitle: displayTitle, grouped: false)
                    .padding(.horizontal)
                    .padding(.bottom, 5)
                HStack(alignment: .top, spacing: 0) {
                    
                    //Movie poster:
                    
                    if let movie = movieFS {
                        if review.reviewText != "" {
                            AsyncImage(url: movie.photoUrl){ image in
                                image
                                    .resizable()
                                    .scaledToFill()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 100, height: 150, alignment: .center)
                            .cornerRadius(5)
                            .overlay(RoundedRectangle(cornerRadius: 5).stroke(.black, lineWidth: 2))
                            .onTapGesture {
                                loadMovie(id: movie.id!)
                                showMovieView = true
                            }
                            .padding(.leading)
                            .padding(.bottom, 5)
                        } else {
                            Rectangle()
                                .frame(width: 0, height: 20)
                                .foregroundColor(.clear)
                                .padding(.leading)
                        }
                    }
                    
                    
                    VStack(spacing: 0) {
                        if displayName && displayTitle {
                            ClapperLine(review: review)
                                .padding(.bottom, 5)
                        }
                        
                        if review.reviewText != "" {
                            ReviewTextView(review: review, grouped: false, heightConstant: displayName ? displayTitle ? 115 : .infinity : 140, blurSpoiler: spoilerCheck ? (!rm.dismissedSpoiler.contains(review.id) && blurSpoiler) : false)
                                .padding(.bottom, 5)
                        }
                        gap(height: 0)
                    }
                    .padding(.horizontal, 5)
                }
                Divider()
                    .background(darkmode ? .black : .white)
                    .padding(.bottom, 5)
                ReviewTab(review: review)
                    .padding(.horizontal)
            }
            .padding(.top)
            .padding(.bottom, 7)
        }
    }
    
    
    func loadMovie(id: String) {
        currentMovie = nil
        movieViewModel.fetchMovie(id: Int(id)!) { result in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let movie):
                    currentMovie = movie
                }
            }
        }
    }
}

struct GroupHeader: View {
    var reviews: [Review]
    
    @Binding var currentMovie: Movie?
    @Binding var showMovieView : Bool
    
    @Binding var userProfile: User?
    @Binding var showProfileView : Bool
    var blurSpoiler: Bool
    
    private let movieViewModel: MovieViewModel = MovieViewModel.shared
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color(GRADIENT_TOP) , Color(GRADIENT_BOTTOM)]), startPoint: .top, endPoint: .bottom)
                .mask(RoundedRectangle(cornerRadius: 25, style: .continuous))
                .shadow(radius: 10)
                .onTapGesture {
                    loadMovie(id: "\(reviews[0].movieId)")
                    showMovieView = true
                }
            VStack(spacing: 5){
                HStack(alignment: .top, spacing: 0) {
                    if reviews.count > 0 {
                        AsyncImage(url: rm.getMovieFS(movieId: "\(reviews[0].movieId)")?.photoUrl) { image in
                            image
                                .resizable()
                                .scaledToFill()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 100, height: 150, alignment: .center)
                        .cornerRadius(5)
                        .overlay(RoundedRectangle(cornerRadius: 5).stroke(.black, lineWidth: 2))
                        .onTapGesture {
                            loadMovie(id: "\(reviews[0].movieId)")
                            showMovieView = true
                        }
                        
                        VStack() {
                            Text(rm.getMovieFS(movieId: "\(reviews[0].movieId)")!.title)
                                .font(Font.headline.weight(.bold))
                                .font(Font.system(size: 25))
                                .minimumScaleFactor(0.5)
                                .lineLimit(2)
                            
                            AverageRatingLine(movieId: reviews[0].movieId, onlyFriends: false)
                                .padding(.leading)
                            AverageRatingLine(movieId: reviews[0].movieId, onlyFriends: true)
                                .padding(.leading)
                        }
                    }
                    
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top)
                
                Divider()
                
                VStack(spacing: 3) {
                    ForEach(reviews, id: \.self) { review in
                        ReviewCardGrouped(review: review, displayName: true, displayTitle: false, blurSpoiler: blurSpoiler, showProfileView: $showProfileView, userProfile: $userProfile)
                    }
                }
                .padding(.horizontal, 5)
                .padding(.bottom, 5)
            }
        }
    }
    
    func loadMovie(id: String) {
        currentMovie = nil
        movieViewModel.fetchMovie(id: Int(id)!) { result in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let movie):
                    currentMovie = movie
                }
            }
        }
    }
}

struct AverageRatingLine: View {
    let movieId: Int
    let onlyFriends: Bool
    
    var body: some View {
        HStack {
            Image(systemName: onlyFriends ? "person.2.circle" : "globe.europe.africa")
                .font(.system(size: 20))
            
            ZStack {
                RoundedRectangle(cornerRadius: 5)
                    .frame(width: 115, height: 25)
                    .foregroundColor(Color(GRADIENT_TOP))
                
                HStack(spacing: 2) {
                    ForEach(1..<6) { i in
                        ReviewClapper(pos: i, score: "\(rm.getAverageRating(movieId: movieId, onlyFriends: onlyFriends))", movieId: movieId, gray: false)
                    }
                }
            }
            Text((rm.getAverageRating(movieId: movieId, onlyFriends: onlyFriends) == Float(Int(rm.getAverageRating(movieId: movieId, onlyFriends: onlyFriends)))) ? String(rm.getAverageRating(movieId: movieId, onlyFriends: onlyFriends)).prefix(1) : String(rm.getAverageRating(movieId: movieId, onlyFriends: onlyFriends)).prefix(3))
                .frame(maxWidth: 30, alignment: .leading)
                .font(Font.headline.weight(.bold))
                .font(.system(size: 20))
        }
    }
}

struct ReviewCardGrouped : View {
    @AppStorage("darkmode") private var darkmode = true
    @AppStorage("spoilerCheck") private var spoilerCheck = true
    
    let review: Review
    let height = 18
    
    let displayName: Bool
    let displayTitle: Bool
    var blurSpoiler: Bool
    
    @Binding var showProfileView: Bool
    @Binding var userProfile: User?
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .foregroundColor(.black)
                .opacity(0.1)
            
            VStack(spacing: 0) {
                ReviewTopView(review: review, showProfileView: $showProfileView, userProfile: $userProfile, displayName: displayName, displayTitle: displayTitle, grouped: true)
                    .padding(.horizontal)
                    .padding(.bottom, 5)
                HStack(alignment: .top, spacing: 0) {
                    VStack(spacing: 0) {
                        if review.reviewText != "" {
                            ReviewTextView(review: review, grouped: true, heightConstant: CGFloat(height), blurSpoiler: spoilerCheck ? (!rm.dismissedSpoiler.contains(review.id) && blurSpoiler) : false)
                            

                                .padding(.bottom, 5)
                        }
                    }
                    .padding(.horizontal, 5)
                }
            }
            .padding(.top)
            .padding(.bottom, 7)
        }
    }
}

struct ReviewTopView: View {
    @State var review: Review
    
    @Binding var showProfileView: Bool
    @Binding var userProfile: User?
    
    let displayName: Bool
    let displayTitle: Bool
    let grouped: Bool
    
    var body: some View {
        HStack(alignment: .top) {
            //Profile picture:
            AsyncImage(url: um.getUser(id: review.authorId).photoUrl) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                ProgressView()
            }
            .frame(width: grouped ? 40 : 50, height: grouped ? 40 : 50 , alignment: .center)
            .cornerRadius(25)
            .onTapGesture {
                loadProfile()
            }
            
            VStack(alignment: .leading, spacing: 5) {
                HStack(alignment: .top) {
                    if displayName {
                        Text(um.getUser(id: review.authorId).username)
                            .font(Font.system(size: 15).italic())
                            .font(Font.system(size: 25))
                            .onTapGesture {
                                loadProfile()
                            }
                    } else {
                        Text(rm.getMovieFS(movieId: String(review.movieId))!.title)
                            .font(Font.headline.weight(.bold))
                            .font(Font.system(size: 25))
                            .minimumScaleFactor(0.5)
                            .lineLimit(2)
                    }
                    Spacer()
                    Text(formatDate(date: review.timestamp))
                        .font(.system(size: 12))
                }
                
                if displayTitle && displayName {
                    Text(rm.getMovieFS(movieId: String(review.movieId))!.title)
                        .font(Font.headline.weight(.bold))
                        .minimumScaleFactor(0.5)
                        .lineLimit(2)
                    
                } else {
                    HStack{
                        ClapperLine(review: review)
                        if grouped {
                            LikeLine(review: $review)
                        }
                    }
                }
            }
        }
        .frame(height: 60)
    }
    
    func loadProfile() {
        userProfile = um.getUser(id: review.authorId)
        um.refresh += 1
        rm.refresh += 1
        showProfileView = true
    }
}

struct ReviewTextView: View {
    @AppStorage(SPOILER) private var spoilerCheck = true
    @AppStorage(DARKMODE) private var darkmode = true
    
    let review: Review
    let grouped: Bool
    let heightConstant: CGFloat
    var blurSpoiler: Bool
    
    @State var lineLimit: Int = 1
    
    @State var showSpoiler = true
    
    @State var height: CGFloat = 0
    @State var fullText = false
    
    var body: some View {
        ZStack(alignment: .topLeading){
            
            RoundedRectangle(cornerRadius: grouped ? 20 : 5, style: .continuous)
                .foregroundColor(.black)
                .opacity(0.1)
            
            Text(review.reviewText)
                .font(.system(size: 15))
                .lineLimit(fullText ? 450 : lineLimit)
                .fixedSize(horizontal: false, vertical: fullText ? true : false)
                .padding(.horizontal, 5)
                .padding(.vertical, 3)
                .blur(radius: showSpoiler ? 0 : 8)
                .onAppear {
                    self.height = heightConstant
                    switch heightConstant {
                    case .infinity:
                        lineLimit = 450

                    case 115:
                        lineLimit = 6

                    case 140:
                        lineLimit = 8

                    default:
                        lineLimit = 1
                    }
                    lineLimit = grouped ? 1 : lineLimit
                }
            
            if !showSpoiler {
                
                Button {
                    showSpoiler = true
                    rm.dismissedSpoiler.append(review.id)
                } label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: grouped ? 20 : 5, style: .continuous)
                            .foregroundColor(.clear)
                        Text("SPOILER")
                            .fontWeight(.bold)
                    }
                    
                    
                }
                .padding(5)
                .foregroundColor(darkmode ? .white : .black)
                .cornerRadius(15)
                .opacity(showSpoiler ? 0 : 1)
                .disabled(showSpoiler)
                
            }
        }
        .onTapGesture {
            withAnimation() {
                if !self.fullText {
                    self.fullText = true
                    self.height = .infinity
                } else {
                    self.fullText = false
                    self.height = heightConstant
                }
            }
        }
        .onAppear {
            if spoilerCheck && blurSpoiler {
                showSpoiler = false
            }
        }
    }
}

struct ReviewTab: View {
    @State var review: Review
    let tagSize: CGFloat = 25
    
    var body: some View {
        HStack{
            if review.whereAt != "" || review.withWho != "" {
                if review.whereAt == HOME {
                    Image(systemName: "house.circle")
                        .font(.system(size: tagSize))
                } else if review.whereAt == CINEMA {
                    Image(systemName: "film.circle")
                        .font(.system(size: tagSize))
                }
                
                if review.withWho == ALONE {
                    Image(systemName: "person.circle")
                        .font(.system(size: tagSize))
                } else if review.withWho == W_FRIENDS {
                    Image(systemName: "person.2.circle")
                        .font(.system(size: tagSize))
                }
            }
            Spacer()
            LikeLine(review: $review)
        }
    }
}

struct LikeLine: View {
    @Binding var review: Review
    
    var body: some View {
        HStack(spacing: 0) {
            Text("\(review.likes.count)")
                .font(.system(size: 12))
            LikeButton(review: review, isLiked: review.likes.contains(um.currentUser!.id!))
        }
    }
}

struct ClapperLine: View {
    let review: Review
    
    var body: some View {
        HStack {
            ForEach(1..<6) { i in
                ClapperImage(pos: i, score: "\(review.rating)")
            }
            Spacer()
        }
    }
}

struct ClapperImage: View {
    let pos : Int
    var score : String
    @State var filled : Bool = false
    
    var body: some View {
        Image(CLAPPER)
            .resizable()
            .frame(width: 20, height: 20)
            .foregroundColor(filled ? Color(BW) : .black)
            .opacity(filled ? 1 : 0.2)
            .onAppear(perform: {
                if Int(score.prefix(1)) ?? 0 >= pos {
                    filled = true
                } else {
                    filled = false
                }
            })
    }
}

