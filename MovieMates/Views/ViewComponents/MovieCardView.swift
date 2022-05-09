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
                Image(systemName: "film")
                    .aspectRatio(CGSize(width: 2, height: 3), contentMode: .fit)
                    .frame(width: 100, height: 150, alignment: .center)
                    .border(Color.black, width: 3)
                VStack(alignment: .leading){
                    Text(movie.title!)
                        .font(.title2)
                        .padding(.bottom, 4)
                        .lineLimit(2)
                    
                    Text(movie.overview ?? "")
                    Spacer()
                }
                Spacer()
            }
            .padding()
        }
    }
}

//struct MovieCardView_Previews: PreviewProvider {
//    static var previews: some View {
//        MovieCardView()
//    }
//}
