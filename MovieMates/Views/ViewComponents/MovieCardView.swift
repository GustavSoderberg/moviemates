//
//  MovieCardView.swift
//  MovieMates
//
//  Created by Joakim Andersson on 2022-05-05.
//

import SwiftUI

struct MovieCardView: View {
    @AppStorage("darkmode") private var darkmode = true
    
    let movie: Movie
    @State var showMovieView = false
    @State var isUpcoming: Bool = false
    
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color(.systemGray), Color(.systemGray2)]), startPoint: .top, endPoint: .bottom)
                .mask(RoundedRectangle(cornerRadius: 25, style: .continuous))
                .shadow(radius: 8)
            HStack(alignment: .top) {
                ZStack{
                    if movie.posterPath != nil {
                        AsyncImage(url: URL(string: "\(BACKDROP_BASE_URL)\(movie.posterPath!)")){ image in
                            image
                                .resizable()
                                .aspectRatio(CGSize(width: 2, height: 3), contentMode: .fit)
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 100, height: 150, alignment: .center)
                        .cornerRadius(5)
                        .overlay(RoundedRectangle(cornerRadius: 5).stroke(.black, lineWidth: 2))
                    } else {
                        Image(systemName: "film")
                            .aspectRatio(CGSize(width: 2, height: 3), contentMode: .fit)
                            .frame(width: 100, height: 150, alignment: .center)
                            
                            .overlay(RoundedRectangle(cornerRadius: 5).stroke(.black, lineWidth: 2))
                    }
                }
             
                VStack(alignment: .leading){
                    Text(movie.title!)
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.bottom, 2)
                        .lineLimit(2)
                        .minimumScaleFactor(0.7)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                    Spacer()
                    Text(movie.overview ?? "")
                        .lineLimit(5)
                        .font(.system(size: 16))
                        
                    Spacer()
                        
                }
                .frame(height: 150)
            }
            .padding()
        }
        .onTapGesture {
            print("click!")
            showMovieView = true
        }
        .sheet(isPresented: $showMovieView) {
            MovieViewController(movie: movie, isUpcoming: isUpcoming, showMovieView: $showMovieView)
                .preferredColorScheme(darkmode ? .dark : .light)
        }
    }
}

//struct MovieCardView_Previews: PreviewProvider {
//    static var previews: some View {
//        MovieCardView(movie: Movie(id: 1, adult: nil, backdropPath: "/f53Jujiap580mgfefID0T0g2e17.jpg", genreIDS: nil, originalLanguage: nil, originalTitle: nil, overview: "Poe Dameron and BB-8 must face the greedy crime boss Graballa the Hutt, who has purchased Darth Vader’s castle and is renovating it into the galaxy’s first all-inclusive Sith-inspired luxury hotel.", releaseDate: nil, posterPath: "/fYiaBZDjyXjvlY6EDZMAxIhBO1I.jpg", popularity: nil, title: "LEGO Star Wars Terrifying Tales", video: nil, voteAverage: nil, voteCount: nil), isUpcoming: false)
//    }
//}
// 
