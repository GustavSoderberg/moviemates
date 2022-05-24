//
//  ReviewView.swift
//  MovieMates
//
//  Created by Oscar Karlsson on 2022-05-23.
//

import SwiftUI

struct ReviewCard: View {
    
    let review: Review
    var movieFS: MovieFS?
    @Binding var currentMovie: Movie?
    @Binding var showMovieView : Bool
    let displayName: Bool
    let displayTitle: Bool
    @Binding var showProfileView: Bool
    @Binding var userProfile: User?
    
    private let movieViewModel: MovieViewModel = MovieViewModel.shared
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color("welcome-clapper-top") , Color("welcome-clapper-bottom")]), startPoint: .top, endPoint: .bottom)
                .mask(RoundedRectangle(cornerRadius: 25, style: .continuous)
                    .fill(Color("secondary-background")))
                .shadow(radius: 10)
                .onTapGesture {
                    loadMovie(id: String(review.movieId))
                    showMovieView = true
                }
            
            VStack(spacing: 0) {
                ReviewTopView(review: review, displayName: displayName, displayTitle: displayTitle)
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
                            .border(Color.black, width: 3)
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
                            ReviewTextView(reviewText: review.reviewText)
                                .padding(.bottom, 5)
                        }
                        gap(height: 0)

                    }
                    .padding(.horizontal, 5)
                }
                Divider()
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

struct ReviewTopView: View {
    let review: Review
    let displayName: Bool
    let displayTitle: Bool
    
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
            .frame(width: 50, height: 50, alignment: .center)
            .cornerRadius(25)
            .onTapGesture {
                //Go to profile
            }
            
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    if displayName {
                        Text(um.getUser(id: review.authorId).username)

//                            .onTapGesture {
//                                print("CLICK")
//                            userProfile = um.getUser(id: review.authorId)
//                                print(userProfile!.username)
//                            um.refresh += 1
//                            showProfileView = true
//                        }

                    } else {
                        Text(um.getMovie(movieID: String(review.movieId))!.title)
                            .font(Font.headline.weight(.bold))
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
                    ClapperLine(review: review)
                }
            }
        }
        .frame(height: 60)
    }
}

struct ReviewTextView: View {
    let reviewText: String
    @State var fullText = false
    @State var lineLimit = 3
    
    var body: some View {
        ZStack(alignment: .topLeading){
            RoundedRectangle(cornerRadius: 5, style: .continuous)
                .foregroundColor(.black)
                .opacity(0.1)
            
            Text(reviewText)
                .font(.system(size: 15))
                .lineLimit(lineLimit)
                .padding(5)
        }
        .onTapGesture {
            withAnimation() {
                if !fullText {
                    fullText = true
                    lineLimit = .max
                } else {
                    fullText = false
                    lineLimit = 3
                }
            }
        }
    }
}

struct ReviewTab: View {
    let review: Review
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
            VStack(spacing: 0) {
                LikeButton()
//                        Text("2")
//                            .font(.system(size: 12))
            }
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
