//
//  LikeReview.swift
//  MovieMates
//
//  Created by Sarah Lidberg on 2022-05-23.
//

import SwiftUI

struct LikeButton: View {
    let review: Review
    @State var isLiked: Bool
    @State var scale: CGFloat = 1
    @State var opacity = 0.0
    @State var likeCounter = 0
    
    var body: some View {
        ZStack{
            Image(systemName: "heart")
            
            Image(systemName: "heart.fill")
                .scaleEffect(isLiked ? 1.0 : 0)
        
        }.font(.system(size: 25))
            .onTapGesture {
                rm.toggleLike(review: review, removeLike: isLiked)
                withAnimation{
                    self.isLiked.toggle()
                }
             }
            .foregroundColor(isLiked ? .red : .white)
    }
}
