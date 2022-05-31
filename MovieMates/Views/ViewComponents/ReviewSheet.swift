/**
 
 - Description:
    This is where a review of a movie is made. Here we get the chosen movie we want to review and then save to Firebase.
 
 - Authors:
    Karol Ö
    Oscar K
    Sarah L
    Joakim A
    Denis R
    Gustav S
 
 */

import SwiftUI

struct ReviewSheet: View {
    @AppStorage("darkmode") private var darkmode = false
    
    @Environment(\.dismiss) var dismiss
    
    @Binding var sheetShowing: Sheet
    @Binding var currentMovie: Movie
    
    @State private var score = 0
    @State private var scoreWidth: CGFloat = 0
    @State private var whereAt = ""
    @State private var withWho = ""
    @State var review: String = ""
    @State var emptyRating = false
    
    var body: some View {
        VStack{
            ScrollView{
                HStack {
                    Text("Cancel")
                        .foregroundColor(.blue)
                        .padding(.top, 4)
                        .onTapGesture {
                            withAnimation(.easeIn(duration: 0.3)){
                                sheetShowing = .MovieView
                            }
                        }
                    Spacer()
                }.onAppear {
                    let existingReview = rm.getReview(movieId: "\(currentMovie.id)")
                    score = existingReview.rating
                    review = existingReview.reviewText
                    whereAt = existingReview.whereAt
                    withWho = existingReview.withWho
                }
                .padding(.horizontal)
                
                VStack {
                    ZStack() {
                        LinearGradient(gradient: Gradient(colors: [Color("welcome-clapper-top") , Color("welcome-clapper-bottom")]), startPoint: .top, endPoint: .bottom)
                            .mask(RoundedRectangle(cornerRadius: 15, style: .continuous))
                            .shadow(radius: 10)
                        
                        HStack{
                            VStack{
                                AsyncImage(url: currentMovie.posterURL) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 100, height: 150, alignment: .center)
                                .cornerRadius(5)
                                .overlay(RoundedRectangle(cornerRadius: 5).stroke(.black, lineWidth: 2))
                            }
                            
                            VStack(spacing: 0) {
                                Text(currentMovie.title ?? "Title")
                                    .multilineTextAlignment(.center)
                                    .padding(.bottom, 10)
                                    .padding(.trailing)
                                Text(emptyRating ? "Pick your rating *" : "Pick your rating")
                                    .font(Font.headline.weight(.bold))
                                    .padding(.bottom, 5)
                                    .foregroundColor(emptyRating ? (darkmode ? .black : .red) : (darkmode ? .white : .black))
                                
                                
                                //Score Picker "Slider"
                                ZStack(alignment: .center) {
                                    RoundedRectangle(cornerRadius: 5)
                                        .frame(width: 160, height: 35)
                                        .foregroundColor(Color("secondary-background"))
                                    
                                    GeometryReader { geo in
                                        Rectangle()
                                            .frame(width: 145, height: 25)
                                            .foregroundColor(.black)
                                            .opacity(0.2)
                                        
                                        Rectangle()
                                            .frame(width: scoreWidth, height: 25)
                                            .foregroundColor(Color("black-white"))
                                        
                                        HStack(spacing: 0) {
                                            ForEach(1..<6, id: \.self){ i in
                                                ClapperScoreSlider(pos: i, score: $score)
                                                
                                                Rectangle()
                                                    .frame(width: 5, height: 25)
                                                    .foregroundColor(Color("secondary-background"))
                                            }
                                        }
                                        .onChange(of: score) { _ in
                                            withAnimation(.easeIn(duration: 0.3)) {
                                                scoreWidth = CGFloat(score*30)
                                            }
                                        }
                                    }
                                    .frame(width: 145, height: 25)
                                }
                                .frame(width: 200)
                            }
                        }
                        .padding()
                    }
                    .padding(.horizontal)
                    
                    VStack(spacing: 0){
                        ZStack{
                            Rectangle()
                                .cornerRadius(15, corners: [.topLeft, .topRight])
                                .frame(height: 30)
                                .foregroundColor(Color("secondary-background"))
                            VStack(spacing: 0) {
                                Text("Write your review")
                                    .font(Font.headline.weight(.bold)) .padding(.vertical, 5)
                                
                                Divider()
                            }
                        }
                        .padding(.horizontal)
                        
                        ZStack{
                            LinearGradient(gradient: Gradient(colors: [Color("secondary-background") , .gray]), startPoint: .top, endPoint: .bottom)
                                .mask(Rectangle()
                                    .cornerRadius(15, corners: [.bottomLeft, .bottomRight])
                                    .frame(height: 170))
                                .shadow(radius: 10)
                            
                            VStack(spacing: 0){
                                ScrollView{
                                    TextEditor(text: $review)
                                        .onReceive(review.publisher.collect()) {
                                                self.review = String($0.prefix(500))
                                            }
                                        .lineLimit(6)
                                        .foregroundColor(darkmode ? .white : .black)
                                        .background(.clear)
                                        .frame(height: 170)
                                        .cornerRadius(15, corners: [.bottomLeft, .bottomRight])
                                }
                                .frame(maxHeight: 170)
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    VStack{
                        
                        Text("Where did you watch the movie?")
                        
                        Picker(selection: $whereAt, label: Text("Question one")){
                            Text("Home").tag("home")
                            Text("Cinema").tag("cinema")
                        }.pickerStyle(SegmentedPickerStyle())
                            .frame(width: 300)
                        
                        Text("How did you watch the movie?")
                        
                        Picker(selection: $withWho, label: Text("Question one")){
                            Text("Alone").tag("alone")
                            Text("With friends").tag("friends")
                        }.pickerStyle(SegmentedPickerStyle())
                            .frame(width: 300)
                        
                    }
                    .padding(.bottom, 50)
                    
                    HStack {
                        Button {
                            if score > 0 {
                                rm.saveReview(movie: currentMovie,
                                              rating: score,
                                              text: review,
                                              whereAt: whereAt,
                                              withWho: withWho)
                                rm.cacheGlobal = rm.getAverageRating(movieId: currentMovie.id, onlyFriends: false)
                                rm.cacheFriends = rm.getAverageRating(movieId: currentMovie.id, onlyFriends: true)
                                rm.refresh += 1
                                withAnimation(.easeIn(duration: 0.3)){
                                    sheetShowing = .MovieView
                                }
                            } else {
                                emptyRating = true
                            }
                        } label: {
                            Text("Leave Review")
                                .frame(width: 200, height: 50)
                        }.buttonStyle(.plain)
                            .frame(width: 200, height: 50)
                        
                            .background(LinearGradient(gradient: Gradient(colors: [Color("welcome-clapper-top"), Color("welcome-clapper-bottom")]), startPoint: .top, endPoint: .bottom)
                                //.mask(RoundedRectangle(cornerRadius: 25, style: .continuous))
                                .shadow(radius: 4))
                            .cornerRadius(10)
                        
                    }
                    Spacer()
                }
            }
        }
        .onAppear(perform: {
            UITextView.appearance().backgroundColor = .clear
        })
    }
}

struct ClapperScoreSlider: View {
    var pos : Int
    @Binding var score : Int
    
    var body: some View {
        Image("clapper_hollow")
            .resizable()
            .frame(width: 25, height: 25)
            .foregroundColor(Color("secondary-background"))
            .onTapGesture {
                score = pos
            }
    }
}

