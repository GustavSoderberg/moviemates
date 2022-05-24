//
//  LikeReview.swift
//  MovieMates
//
//  Created by Sarah Lidberg on 2022-05-23.
//

import SwiftUI

struct LikeButton: View {
    
    @Binding var review: Review
    @State var scale: CGFloat = 1
    @State var opacity = 0.0
    @State var isLiked = false
    
    var body: some View {
        
        Button {
            
            if !review.likes.contains(um.currentUser!.id!) {
                um.like(review: review)
                
                isLiked = true
                
            } else {
                um.dislike(review: review)
                
                isLiked = false
                
            }
            
        } label: {
            ZStack{
                
                Image(systemName: "heart")
                
                Image(systemName: "heart.fill")
                    .onAppear(){
                        self.isLiked = review.likes.contains(um.currentUser!.id!)
                    }
                //.opacity(isLiked ? 1 : 0)
                    .scaleEffect(isLiked ? 1.0 : 0)
                
                
            }.font(.system(size: 25))
        }.foregroundColor(isLiked ? .red : .white)
        
        //            .onTapGesture {
        //                withAnimation{
        //                    if !review.likes.contains(um.currentUser!.id!) {
        //                        um.like(review: review)
        //
        //                        isLiked = true
        //
        //                    } else {
        //                        um.dislike(review: review)
        //
        //                        isLiked = false
        //
        //                    }
        //                }
        //
        //             }
        
    }
    
}

//struct LikeButton_Previews: PreviewProvider {
//    static var previews: some View {
//        LikeButton()
//    }
//}
