/**
 
 - Description:
    Here we make the like button that is shown on ReviewView.
 
 - Authors:
    Karol Ö
    Oscar K
    Sarah L
    Joakim A
    Denis R
    Gustav S
 
 */

import SwiftUI

struct LikeButton: View {
    @AppStorage("darkmode") private var darkmode = true
    
    let review: Review
    @State var isLiked: Bool
    @State var scale: CGFloat = 1
    @State var opacity = 0.0
    @State var likeCounter = 0
    
    var body: some View {
        ZStack{
            Image(systemName: "heart")
            
            Image(systemName: "heart.fill")
                .scaleEffect(isLiked ? 1.0 : 0.001)
        
        }.font(.system(size: 25))
            .onTapGesture {
                rm.toggleLike(review: review, removeLike: review.likes.contains(um.currentUser!.id!))
                withAnimation {
                    self.isLiked = review.likes.contains(um.currentUser!.id!)
                }
             }
            .foregroundColor(darkmode ? isLiked ? .red : .white : isLiked ? .red : .black)
    }
}
