//
//  ReviewView.swift
//  MovieMates
//
//  Created by Oscar Karlsson on 2022-05-23.
//

import SwiftUI

struct ReviewCard: View {
    
    @AppStorage("darkmode") private var darkmode = true
    
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
            LinearGradient(gradient: Gradient(colors: [Color("welcome-clapper-top") , Color("welcome-clapper-bottom")]), startPoint: .top, endPoint: .bottom)
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
                            ReviewTextView(reviewText: review.reviewText, grouped: false, heightConstant: displayName ? displayTitle ? 115 : .infinity : 140, blurSpoiler: blurSpoiler)
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
            LinearGradient(gradient: Gradient(colors: [Color("welcome-clapper-top") , Color("welcome-clapper-bottom")]), startPoint: .top, endPoint: .bottom)
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
                            
                            AverageReviewsLine(movieId: reviews[0].movieId, onlyFriends: false)
                                .padding(.leading)
                            AverageReviewsLine(movieId: reviews[0].movieId, onlyFriends: true)
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

struct AverageReviewsLine: View {
    let movieId: Int
    let onlyFriends: Bool
    
    var body: some View {
        HStack {
            Image(systemName: onlyFriends ? "person.2.circle" : "globe.europe.africa")
                .font(.system(size: 20))
            
            ZStack {
                RoundedRectangle(cornerRadius: 5)
                    .frame(width: 115, height: 25)
                    .foregroundColor(Color("accent-color"))
                
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
    
    let review: Review
    
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
                            ReviewTextView(reviewText: review.reviewText, grouped: true, heightConstant: 18, blurSpoiler: blurSpoiler)
                                .padding(.bottom, 5)
                        }
                        gap(height: 0)
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
                        Text(um.getMovie(movieID: String(review.movieId))!.title)
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
                    Text(um.getMovie(movieID: String(review.movieId))!.title)
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
    
    @AppStorage("spoilerCheck") private var spoilerCheck = true
    @AppStorage("darkmode") private var darkmode = true
    
    let reviewText: String
    let grouped: Bool
    let heightConstant: CGFloat
    var blurSpoiler: Bool
    
    @State var showSpoiler = false
    
    @State var height: CGFloat
    @State var fullText = false
    
    init(reviewText: String, grouped: Bool, heightConstant: CGFloat, blurSpoiler: Bool) {
        self.reviewText = reviewText
        self.grouped = grouped
        self.heightConstant = heightConstant
        self.blurSpoiler = blurSpoiler
        showSpoiler = !blurSpoiler
        height = heightConstant
        //check date
    }
    
    var body: some View {
        ZStack(alignment: .topLeading){
            
            RoundedRectangle(cornerRadius: grouped ? 20 : 5, style: .continuous)
                .foregroundColor(.black)
                .opacity(0.1)
            
            Text(reviewText)
                .font(.system(size: 15))
                .frame(height: height, alignment: .topLeading)
                .padding(5)
                .blur(radius: showSpoiler ? 0 : 8)
            
            if spoilerCheck && blurSpoiler   {
                
                Button {
                    print(spoilerCheck)
                    showSpoiler = true
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
            //            else {
            //
            //                Text(reviewText)
            //                    .font(.system(size: 15))
            //                    .frame(height: height, alignment: .topLeading)
            //                    .padding(5)
            //
            //
            //            }
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
    }
}

struct ReviewTab: View {
    @State var review: Review
    let tagSize: CGFloat = 25
    
    var body: some View {
        HStack{
            if review.whereAt != "" || review.withWho != "" {
                if review.whereAt == "home" {
                    Image(systemName: "house.circle")
                        .font(.system(size: tagSize))
                } else if review.whereAt == "cinema" {
                    Image(systemName: "film.circle")
                        .font(.system(size: tagSize))
                }
                
                if review.withWho == "alone" {
                    Image(systemName: "person.circle")
                        .font(.system(size: tagSize))
                } else if review.withWho == "friends" {
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

