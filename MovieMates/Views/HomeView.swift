//
//  HomeView.swift
//  MovieMates
//
//  Created by Gustav Söderberg on 2022-05-02.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        HStack{
            List(reviews){ review in
                HStack{
                    Image(systemName: "film")
                        .aspectRatio(CGSize(width: 2, height: 3), contentMode: .fit)
                        .frame(width: 100, height: 150, alignment: .center)
                        .border(Color.black, width: 3)
                    VStack(alignment: .leading){
                        Spacer()
                        Text(review.username)
                        Spacer()
                        Text(review.title)
                            .font(.title)
                        Spacer()
                        Text(review.reviewText)
                        Spacer()
                    }
                }
            }
        }
    }
}


struct Review: Identifiable {
    var id = UUID()
    
    let username: String
    let title: String
    let reviewText: String
}

private var reviews = [
    Review(username: "Sarah", title: "The Batman", reviewText: "Review Text"),
    Review(username: "Oscar", title: "The Duckman", reviewText: "Review Text"),
    Review(username: "Joakim", title: "The Birdman", reviewText: "Review Text")
]

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
