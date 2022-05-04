//
//  MovieView.swift
//  MovieMates
//
//  Created by Oscar Karlsson on 2022-05-03.
//

import SwiftUI

struct MovieView: View {
    @State var title : String = "Movie Title"
    @State var description : String = "Movie Description"
    @State var ratingGlobalWidth : Float = 30
    @State var ratingLocalWidth : Float = 90
    @State var ratingGlobalScore : String = "0"
    @State var ratingLocalScore : String = "0"
    
    var body: some View {
        VStack(spacing: 0){
            HStack{
                Image("bill_poster")
                    .resizable()
                    .frame(width: 80, height: 140)
                VStack {
                    Text("Movie Title")
                    Text("Movie Description")
                }
            }
            HStack{
                Text("RATINGS:")
                    .padding(.leading)
                Spacer()
            }
        
            ZStack{
                Rectangle()
                    .padding(.horizontal)
                    .frame(height: 80)
                    .foregroundColor(.gray)
                VStack {
                    
                    
                    
                    HStack{
                        Text("GLOBAL")
                            .foregroundColor(.white)
                        Spacer()
                        HStack(spacing: 2) {
                                ForEach(1..<6) { i in
                                    ReviewClapper(pos: i, score: ratingGlobalScore)
                                }
                            }
                        .frame(height: 20)
                        .onAppear(perform: {
                            ratingGlobalScore = String(format: "%.1f", ratingGlobalWidth/20)
                            if ratingGlobalScore.hasSuffix("0") {
                                ratingGlobalScore = String(ratingGlobalScore.prefix(1))
                            }
                        })
                        
                        Text("\(ratingGlobalScore)")
                            .foregroundColor(.white)
                            .frame(maxWidth: 30, alignment: .leading)
                        Spacer()
                    }
                    .padding(.horizontal, 30.0)
                    
                    
                    
                    HStack{
                        Text("FRIENDS")
                            .foregroundColor(.white)
                        Spacer()
                        HStack(spacing: 2) {
                                ForEach(1..<6) { i in
                                    ReviewClapper(pos: i, score: ratingLocalScore)
                                }
                            }
                        .frame(height: 20)
                        .onAppear(perform: {
                            ratingLocalScore = String(format: "%.1f", ratingLocalWidth/20)
                            if ratingLocalScore.hasSuffix("0") {
                                ratingLocalScore = String(ratingLocalScore.prefix(1))
                            }
                        })
                        
                        Text("\(ratingLocalScore)")
                            .foregroundColor(.white)
                            .frame(maxWidth: 30, alignment: .leading)
                        Spacer()
                    }
                    .padding(.horizontal, 30.0)
                }
            }
        }
    }
}

struct ReviewClapper: View {
    var pos : Int
    var score : String
    @State var width : Float = 20
    
    var body: some View {
        GeometryReader { geo in
            Rectangle()
                .frame(width: 20, height: 20)
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.white)
            
            Rectangle()
                .frame(width: CGFloat(width), height: 20)
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.black)
            
            Image("clapper_hollow")
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundColor(.gray)
        }
        .frame(width: 20, height: 20)
        .onAppear(perform: {
            if Int(score.prefix(1)) ?? 0 >= pos {
                width = 20
            } else {
                width = (Float(score.prefix(3)) ?? 0)*2
            }
            print("pos: \(pos) width: \(width)")
        })
    }
}

struct MovieView_Previews: PreviewProvider {
    static var previews: some View {
        MovieView()
    }
}

