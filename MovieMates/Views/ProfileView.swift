//
//  ProfileView.swift
//  MovieMates
//
//  Created by Gustav Söderberg on 2022-05-02.
//

import SwiftUI
import FirebaseAuth


struct ProfileView: View {
    
    @State var index = "reviews"
    @State private var showingSheet = false
    @State private var changeUsername = ""
    @State private var addFriend = false
    
    var body: some View {
        ZStack{
            Color("background")
                .ignoresSafeArea()
            
            VStack{
                
                ZStack{
                    
                    Text(um.currentUser!.username)
                        .font(.largeTitle)
                        .lineLimit(1)
                        .frame(width: 250)
                    
                    HStack{
                        Spacer()
                        
                        if um.currentUser!.id != um.currentUser!.id {
                            Button {
                                print("added friendo")
                            } label: {
                                Image(systemName: "person.crop.circle.badge.plus")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .padding(.trailing, 20)
                            }
                            
                        } else {
                            
                            Button {
                                showingSheet = true
                            } label: {
                                Image(systemName: "slider.horizontal.3")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                    .padding(.trailing, 20)
                            }.sheet(isPresented: $showingSheet) {
                                //FriendRequestTestView(showProfileSheet: $showingSheet)
                                SettingsSheet(showProfileSheet: $showingSheet, changeUsername: $changeUsername)
                                
                            }
                        }
                    }
                    
                }
                Spacer()
                AsyncImage(url: um.currentUser!.photoUrl) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .cornerRadius(50)
                } placeholder: {
                    ProgressView()
                }
                Spacer()
                
                
                Picker(selection: $index,
                       label: Text("Reviews"),
                       content: {
                    Text("Reviews").tag("reviews")
                    Text("Watchlist").tag("watchlist")
                    Text("About").tag("about")
                    
                })
                    .padding()
                    .pickerStyle(SegmentedPickerStyle())
                    .colorMultiply(.red)
                
                
                switch index {
                case "reviews":
                    UserReviewView()
                case "watchlist":
                    WatchListView()
                case "about":
                    AboutMeView()
                default:
                    UserReviewView()
                }
                
                Spacer()
            }
        }
    }
    
}

struct UserReviewView: View {
    var body: some View{
        VStack{
            Text("Hej min favoritfilm är Batman!!")
            ScrollView{
                LazyVStack{
                    ForEach(myReviews) { review in
                        MyReviewCardView(review: review)
                    }
                }
                .padding()
            }
        }
    }
}

struct WatchListView: View {
    var body: some View{
        VStack{
            Text("Jag vill se den nya Dr Strange!!")
            ScrollView{
                LazyVStack{
                    //                    ForEach(watchlist) { movie in
                    //                        MovieCardView(movie: movie)
                    //                    }
                }
                .padding()
            }
        }
    }
}

struct AboutMeView: View {
    
    @State var bio: String = "this is my bio fix me later this is my bio fix me later this is my this is my bio fix me laterthis is my bio fix me laterthis is my bio fix me laterthis is my bio fix me laterthis is my bio fix me laterthis is my bio fix me laterthis is my bio fix me laterthis is my bio fix me laterbio fix me later"
    
    init() {
        UITextView.appearance().backgroundColor = .clear
    }
    
    var body: some View{
        VStack{
            ScrollView{
                HStack{
                    Text("Biography")
                        .font(.title2)
                        .padding()
                    Spacer()
                }
                ZStack(alignment: .leading){
                    RoundedRectangle(cornerRadius: 25, style: .continuous)
                        .fill(Color("secondary-background"))
                        .frame(minHeight: 100)
                    
                    VStack{
                        if um.currentUser!.id != um.currentUser!.id {
                            Text(bio)
                                .padding()
                        }else if um.currentUser!.id == um.currentUser!.id {
                            TextEditor(text: $bio)
                                .background(Color("secondary-background"))
                                .foregroundColor(.white)
                                .frame(minHeight: 100)
                                .cornerRadius(25)
                            
                        }
                        
                        
                        Spacer()
                        
                    }
                }.padding()
                HStack{
                    Text("Summary of \(um.currentUser!.username)")
                        .font(.title2)
                        .padding()
                    Spacer()
                }
                
                ZStack(alignment: .leading){
                    RoundedRectangle(cornerRadius: 25, style: .continuous)
                        .fill(Color("secondary-background"))
                        .frame(minHeight: 100)
                    
                    VStack{
                        Text("about blblblbbababa ska kasokdak ajsjd jiasd jiasdj as bla bla bla ")
                            .padding()
                        Spacer()
                    }
                }.padding()
            }
        }
    }
}




struct MyReviewCardView: View {
    
    let review: Review
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(.gray)
            HStack(alignment: .top){
                Image(systemName: "film")
                    .aspectRatio(CGSize(width: 2, height: 3), contentMode: .fit)
                    .frame(width: 100, height: 150, alignment: .center)
                    .border(Color.black, width: 3)
                VStack(alignment: .leading){
                    
                    Text(review.timestamp.formatted())
                        .font(.system(size: 12))
                        .frame(maxWidth: 1000, alignment: .trailing)
                    
                    Text(review.title)
                        .font(.title)
                    Text(review.rating)
                    Spacer()
                    Text(review.reviewText)
                        .font(.system(size: 15))
                        .lineLimit(3)
                    Spacer()
                }
                Spacer()
            }
            .padding()
        }
    }
}



private var myReviews = [
    Review(movieId: 414906, username: "Sarah", title: "The Batman", rating: "5/5", reviewText: "Siken film! jag grät, jag skrek, jag belv en helt ny människa!"),
    Review(movieId: 414906, username: "Sarah", title: "The Duckman", rating: "4/5", reviewText: "Jag gillar ankor så denna film var helt perfekt för mig! Dock så var det ett himla kvackande i biosalongen."),
    Review(movieId: 414906, username: "Sarah", title: "The Birdman", rating: "1/5", reviewText: "Trodde filmen skulle handla om en fågel som ville bli människa, men det var ju helt fel! Den handlar om en man som trodde han var en fågel. Falsk marknadsföring!"),
    Review(movieId: 414906, username: "Sarah", title: "The Spiderman", rating: "5/5", reviewText: "Jag somnade efter 30min och vaknade strax innan slutet. Bästa tuppluren jag haft på länge! Rekomenderas starkt!")
]

//private var watchlist = [
//    Movie(id: 1, adult: false, backdropPath: nil, genreIDS: nil, originalLanguage: nil, originalTitle: "spider man", overview: "fasdfdsafasdf", releaseDate: nil, posterPath: nil, popularity: nil, title: "Spooder-Man", video: nil, voteAverage: nil, voteCount: nil)
////    Movie(title: "Spooder-Man", description: "See spider man in one of his gazillion movies"),
////    Movie(title: "Star Wars A New Hope", description: "Small farm boy destoys big buisness"),
////    Movie(title: "Bill. A documentary", description: "From teacher to hero, follow this man on his journey through the world of computers")
//]

struct FriendRequestTestView: View {
    @Binding var showProfileSheet: Bool
    @ObservedObject var uq = um
    
    var body: some View {
        ForEach(uq.listOfUsers) { user in
            
            if user.id != um.currentUser!.id! {
                
                if um.currentUser!.friends.contains(user.id!) {
                    Text("\(user.username) is your friend")
                }
                else if um.currentUser!.frequests.contains(user.id!) {
                    Text("\(user.username) has sent you a request")
                }
                else if user.frequests.contains(um.currentUser!.id!) {
                    Text("You've sent \(user.username) a request")
                }
                else {
                    Button {
                        um.friendRequest(to: user)
                    } label: {
                        Text("Add \(user.username)")
                    }
                }

                
            }
            
        }
        
        Text("Requests:").padding().padding(.top,40)
        ForEach(uq.currentUser!.frequests, id: \.self) { request in
            
            Button {
                uq.manageFriendRequests(forId: request, accept: true)
            } label: {
                Text("Accept request from \(request)")
            }
            Button {
                uq.manageFriendRequests(forId: request, accept: false)
            } label: {
                Text("Deny request from \(request)")
            }


            
        }
        
        Text("Friends:").padding().padding(.top,40)
        ForEach(uq.currentUser!.friends, id: \.self) { friend in
            
            Button {
                um.removeFriend(id: friend)
            } label: {
                Text("Remove \(friend)")
            }

            
        }
    }
}
