//
//  HomeView.swift
//  MovieMates
//
//  Created by Gustav Söderberg on 2022-05-02.
//

import SwiftUI

struct HomeView: View {
    @State var index = "friends"
    
    var body: some View {
        ZStack{
            Color("background")
                .ignoresSafeArea()
            VStack{
                Picker(selection: $index, label: Text("Review List"), content: {
                    Text("Friends").tag("friends")
                    Text("Trending").tag("trending")
                    
                })
                    .padding(.horizontal)
                    .padding(.top, 20)
                    .pickerStyle(SegmentedPickerStyle())
            
                ScrollView{
                    LazyVStack{
                        ForEach(reviews) { review in
                            ReviewCardView(review: review)
                        }
                    }
                    .padding()
                }
            }
        }
    }
}

struct ReviewCardView: View {
    
    let review: Review
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(.gray)
            HStack{
                Image(systemName: "film")
                    .aspectRatio(CGSize(width: 2, height: 3), contentMode: .fit)
                    .frame(width: 100, height: 150, alignment: .center)
                    .border(Color.black, width: 3)
                VStack(alignment: .leading){
                    
                    HStack{
                        Text(review.username)
                        Spacer()
                        Text(review.timestamp.formatted())
                            .font(.system(size: 12))
                    }
                    .padding(.bottom, 1)
                    Text(review.title)
                        .font(.title)
                    Text(review.rating)
                    Spacer()
                    Text(review.reviewText)
                    Spacer()
                }
            }
            .padding()
        }
    }
}


struct Review: Identifiable {
    var id = UUID()
    let username: String
    let title: String
    let rating: String
    let reviewText: String
    let timestamp = Date.now
}

private var reviews = [
    Review(username: "Sarah", title: "The Batman", rating: "5/5", reviewText: "Review Text..."),
    Review(username: "Oscar", title: "The Duckman", rating: "5/5", reviewText: "Review Text..."),
    Review(username: "Joakim", title: "The Birdman", rating: "5/5", reviewText: "Review Text..."),
    Review(username: "Gustav", title: "The Spiderman", rating: "5/5", reviewText: "Review Text...")
]

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
