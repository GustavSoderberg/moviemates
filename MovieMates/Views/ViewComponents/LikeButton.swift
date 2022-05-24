//
//  LikeReview.swift
//  MovieMates
//
//  Created by Sarah Lidberg on 2022-05-23.
//

import SwiftUI

struct LikeButton: View {
    @State var scale: CGFloat = 1
    @State var opacity = 0.0
    @State var isLiked = false
    @State var likeCounter = 0
    
    var body: some View {
        ZStack{
            
            Image(systemName: "heart")
            
            Image(systemName: "heart.fill")
                //.opacity(isLiked ? 1 : 0)
                .scaleEffect(isLiked ? 1.0 : 0)
        
        
        }.font(.system(size: 25))
            .onTapGesture {
                likeCounter += 1
                print(likeCounter)
                withAnimation{
                    self.isLiked.toggle()
                }
                    
             }
            .foregroundColor(isLiked ? .red : .white)
    }
    
}

//struct LikeButton_Previews: PreviewProvider {
//    static var previews: some View {
//        LikeButton()
//    }
//}
