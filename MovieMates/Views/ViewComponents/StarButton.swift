//
//  StarButton.swift
//  MovieMates
//
//  Created by Denis Rakitin on 2022-05-30.
//

/**
 - Description: This star button is used when you want to add a movie to watchlist on your profile. You can find this on the discover tab on HomeView. 
 */
import SwiftUI

struct StarButton: View {
    let currentMovie: Movie
    @State var scale: CGFloat = 1
    @State var onWatchlist = false
    
    var body: some View {
        ZStack{
            Image(systemName: "star")
            
            Image(systemName: "star.fill")
                .scaleEffect(onWatchlist ? 1.0 : 0.001)
        
        }
        .onAppear {
            onWatchlist = um.currentUser!.watchlist.contains("\(currentMovie.id)") ? true : false
        }
        .font(.system(size: 25))
            .onTapGesture {
                if !onWatchlist {
                    um.addToWatchlist(movieID: "\(currentMovie.id)")
                    
                    withAnimation {
                        onWatchlist = true
                    }
                    
                } else {
                    um.removeMovieWatchlist(movieID: "\(currentMovie.id)")
                    
                    withAnimation {
                        onWatchlist =  false
                    }
                }
             }
            .foregroundColor(onWatchlist ? .yellow : .white)
    }
}

