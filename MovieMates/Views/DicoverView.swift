//
//  DicoverView.swift
//  MovieMates
//
//  Created by Denis Rakitin on 2022-05-26.
//

/**
 - Description: Creates the view for the CarouselSelection with different types of categories. 
 
 */

import SwiftUI


struct DicoverView: View {
    
    @AppStorage("darkmode") private var darkmode = true
    
    var body: some View {
        ScrollView(.vertical){
            VStack {
                CarouselSection(movieListType: .popular)
                CarouselSection(movieListType: .upcoming)
                CarouselSection(movieListType: .nowPlaying)
                CarouselSection(movieListType: .topRated)
            }
        }
        .frame(maxHeight: .infinity)
    }
}

struct DicoverView_Previews: PreviewProvider {
    static var previews: some View {
        DicoverView()
    }
}
