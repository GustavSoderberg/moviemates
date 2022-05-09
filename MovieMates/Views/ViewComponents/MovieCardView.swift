//
//  MovieCardView.swift
//  MovieMates
//
//  Created by Joakim Andersson on 2022-05-05.
//

import SwiftUI

struct MovieCardView: View {
    
    let movie: Movie
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(.gray)
            HStack {
                if movie.posterPath != nil {
                AsyncImage(url: URL(string: "\(BACKDROP_BASE_URL)\(movie.posterPath!)")){ image in
                    image.resizable()
                    .aspectRatio(CGSize(width: 2, height: 3), contentMode: .fit)
                    .frame(width: 100, height: 150, alignment: .center)
                    .border(Color.black, width: 3)
                } placeholder: {
                    ProgressView()
                }
                } else {
                    Image(systemName: "film")
                        .aspectRatio(CGSize(width: 2, height: 3), contentMode: .fit)
                        .frame(width: 100, height: 150, alignment: .center)
                        .border(Color.black, width: 3)
                }
                VStack(alignment: .leading){
                    Text(movie.title!)
                        .font(.title2)
                        .padding(.bottom, 4)
                        .lineLimit(2)
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    Text(movie.overview ?? "")
                        .lineLimit(6)
                    Spacer()
                }
                Spacer()
            }
            .padding()
        }
    }
}

struct MovieCardView_Previews: PreviewProvider {
    static var previews: some View {
        MovieCardView(movie: Movie(id: 1, adult: nil, backdropPath: "/f53Jujiap580mgfefID0T0g2e17.jpg", genreIDS: nil, originalLanguage: nil, originalTitle: nil, overview: "Poe Dameron and BB-8 must face the greedy crime boss Graballa the Hutt, who has purchased Darth Vader’s castle and is renovating it into the galaxy’s first all-inclusive Sith-inspired luxury hotel.", releaseDate: nil, posterPath: "/fYiaBZDjyXjvlY6EDZMAxIhBO1I.jpg", popularity: nil, title: "LEGO Star Wars Terrifying Tales", video: nil, voteAverage: nil, voteCount: nil))
    }
}
