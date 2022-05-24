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
                HStack(alignment: .top) {
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
                            loadMovie(id: movie.id!)
                            showMovieView = true
                        }
                    }
                    
                    VStack(spacing: 0) {
                        ReviewInfo(review: review, displayName: displayName, displayTitle: displayTitle, showProfileView: $showProfileView, userProfile: $userProfile)
                        Spacer()
                    }
                }

                .padding(.horizontal)
                Divider()
                    .padding(.bottom)
                ReviewTab(review: review)
                    .padding(.horizontal)
            }
            .padding(.vertical)
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



struct ReviewInfo: View {
    
    let review: Review
    let displayName: Bool
    let displayTitle: Bool
    @State var fullText = false
    @State var lineLimit = 3
    @Binding var showProfileView: Bool
    @Binding var userProfile: User?
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 5){
                HStack{
                    if displayName {
                        Text(um.getUser(id: review.authorId).username)
                            .onTapGesture {
                            userProfile = um.getUser(id: review.authorId)
                            rm.refresh += 1
                            showProfileView = true
                        }
                    } else {
                        Text(um.getMovie(movieID: String(review.movieId))!.title)
                    }
                    Spacer()
                    Text(formatDate(date: review.timestamp))
                        .font(.system(size: 12))
                }
                if displayTitle && displayName {
                    Text(um.getMovie(movieID: String(review.movieId))!.title)
                        
                }
                HStack{
                    ForEach(1..<6) { i in
                        ClapperImage(pos: i, score: "\(review.rating)")
                    }
                    Spacer()
                }
                ZStack(alignment: .topLeading){
                    LinearGradient(gradient: Gradient(colors: [.black, .gray]), startPoint: .top, endPoint: .bottom)
                        .mask(RoundedRectangle(cornerRadius: 5, style: .continuous))
                                .shadow(radius: 5)
                                .opacity(0.15)
                                .border(.black, width: 2)
                                .cornerRadius(3)
                    
                    Text(review.reviewText)
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
