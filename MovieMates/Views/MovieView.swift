//
//  MovieView.swift
//  MovieMates
//
//  Created by Oscar Karlsson on 2022-05-03.
//

import SwiftUI
import Alamofire
import UIKit

enum Sheet {
    case MovieView, ReviewSheet
}

struct MovieViewController: View {
    @State var sheetShowing: Sheet = .MovieView
    
    var body: some View {
        
        switch self.sheetShowing {
            
        case .MovieView:
            MovieView(sheetShowing: $sheetShowing, movieID: "268")
            
        case .ReviewSheet:
            ReviewSheet()
        }
        
        //sheetShowing = .ReviewSheet
    }
}

struct MovieView: View {
    @Binding var sheetShowing: Sheet
    var movieID: String
    @State var currentMovie: Movie?
    
    @State var title : String = "Movie Title"
    @State var description : String = "Movie Description"
    @State var ratingGlobalWidth : Float = 67
    @State var ratingLocalWidth : Float = 14
    @State var ratingGlobalScore : String = "0"
    @State var ratingLocalScore : String = "0"
    
    var body: some View {
        VStack(spacing: 0){
            HStack{
                Image("bill_poster")
                    .resizable()
                    .frame(width: 80, height: 140)
                VStack {
                    Text(title)
                    Text(description)
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
                                    ReviewClapper(pos: i, score: $ratingGlobalScore)
                                }
                            }
                            .frame(height: 20)
                            
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
                                        ReviewClapper(pos: i, score: $ratingLocalScore)
                                    }
                                }
                            .frame(height: 20)
                            
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
        .onAppear(perform: {
            guard let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieID)?api_key=\(API_KEY)&language=en-US") else {return}
            
            AF.request(url).response { responce in
                switch responce.result {
                case.success(let value):
                    print("val: \(value)") 
                    //self.title = value.title ?? "Title"
                case .failure(let error):
                    print(error)
                }
            }
            
            ratingGlobalWidth = Float(Int.random(in: 1...100))
            ratingLocalWidth = Float(Int.random(in: 1...100))
            ratingGlobalScore = String(format: "%.1f", ratingGlobalWidth/20)
            if ratingGlobalScore.hasSuffix("0") {
                ratingGlobalScore = String(ratingGlobalScore.prefix(1))
            }
            
            ratingLocalScore = String(format: "%.1f", ratingLocalWidth/20)
            if ratingLocalScore.hasSuffix("0") {
                ratingLocalScore = String(ratingLocalScore.prefix(1))
            }
        })
    }
}

struct ReviewClapper: View {
    var pos : Int
    @Binding var score : String
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
            } else if ((Int(score.prefix(1)) ?? 0) + 1) == pos {
                width = ((Float(score.prefix(3)) ?? 0) - (Float(score.prefix(1)) ?? 0))*20
            } else {
                width = 0
            }
            //print("pos: \(pos), score: \(score), width: \(width)")
        })
    }
}

//struct MovieView_Previews: PreviewProvider {
//    static var previews: some View {
//        MovieView()
//    }
//}

