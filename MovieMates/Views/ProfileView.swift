//
//  ProfileView.swift
//  MovieMates
//
//  Created by Gustav Söderberg on 2022-05-02.
//

import SwiftUI
import FirebaseAuth


struct ProfileView: View {
    @AppStorage("darkmode") private var darkmode = true
    @EnvironmentObject var statusController: StatusController
    
    @State var index = "reviews"
    @State private var showSettingsSheet = false
    @State private var showingNotificationSheet = false
    
    @State private var addFriend = false
    var user: User
    
    @State var test = 0
    @ObservedObject var ooum = um
    
    
    
    var body: some View {
        ZStack{
            Color("background")
                .ignoresSafeArea()
            
            VStack{
                
                ZStack{
                    
                    Text(user.username)
                        .font(.largeTitle)
                        .lineLimit(1)
                        .frame(width: 250)
                    
                    HStack{
                        
                        if user.id == ooum.currentUser!.id {
                            if !ooum.notification {
                                
                                Button {
                                    //ooum.notification = true
                                    showingNotificationSheet = true
                                    statusController.viewShowing = .Loading
                                } label: {
                                    Image(systemName: um.currentUser!.frequests.count > 0 ? "bell.badge" : "bell")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                        .padding(.leading, 20)
                                        .foregroundColor(um.currentUser!.frequests.count > 0 ? .yellow : .blue)
                                        
                                }.sheet(isPresented: $showingNotificationSheet) {
                                    NotificationSheet(showNotificationSheet: $showingNotificationSheet)
                                        .preferredColorScheme(darkmode ? .dark : .light)
                                }
                            } else {
                                Button {
                                    //ooum.notification = false
                                } label: {
                                    Image(systemName: "bell.badge")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                        .padding(.leading, 20)
                                        
                                        
                                }
                                
                            }
                        }
                        Spacer()
                        
                        if user.id != ooum.currentUser!.id! {
                            
                            if ooum.currentUser!.friends.contains(user.id!) {
                                
                                Image(systemName: "person.fill.checkmark")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .padding(.trailing, 20)
                                    .foregroundColor(.green)
                                
                            }
                            else if ooum.currentUser!.frequests.contains(user.id!) {
                                Button {
                                    um.manageFriendRequests(forId: user.id!, accept: true)
                                } label: {
                                    Image(systemName: "checkmark.circle")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                        .padding(.trailing, 20)
                                        .foregroundColor(.green)
                                }.buttonStyle(.plain)
                                
                                
                            }
                            else if user.frequests.contains(um.currentUser!.id!) {
                                Image(systemName: "hourglass")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .padding(.trailing, 20)
                                    .foregroundColor(.yellow)
                            }
                            else {
                                Button {
                                    um.friendRequest(to: user)
                                } label: {
                                    Image(systemName: "person.crop.circle.badge.plus")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                        .padding(.trailing, 20)
                                        .foregroundColor(darkmode ? .white : .black)
                                }
                            }
                            
                            
                        }
                        else {
                            
                            Button {
                                showSettingsSheet = true
                            } label: {
                                Image(systemName: "slider.horizontal.3")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                    .padding(.trailing, 20)
                            }.sheet(isPresented: $showSettingsSheet, onDismiss: {
                                if Auth.auth().currentUser == nil { statusController.viewShowing = .WelcomeView }
                            }) {
                                //FriendRequestTestView(showProfileSheet: $showSettingsSheet)
                                SettingsSheet(showSettingsSheet: $showSettingsSheet, user: user)
                                    .preferredColorScheme(darkmode ? .dark : .light)
                                
                            }
                        }
                    }.environmentObject(statusController)
                    
                }
                Spacer()
                AsyncImage(url: user.photoUrl) { image in
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
                    Text("Friends").tag("friends")
                    Text("About").tag("about")
                    
                })
                .padding()
                .pickerStyle(SegmentedPickerStyle())
                .colorMultiply(Color("accent-color"))
                
                
                switch index {
                case "reviews":
                    UserReviewView(user: user)
                case "watchlist":
                    WatchListView(user: user)
                case "friends":
                    FriendListView(user: user)
                case "about":
                    AboutMeView(user: user)
                default:
                    UserReviewView(user: user)
                }
                
                Spacer()
            }
        }
    }
    
}

struct UserReviewView: View {
    @AppStorage("darkmode") private var darkmode = true
    
    let user: User
    @State var currentMovie: Movie? = nil
    @State var showMovieView = false
    @State var showProfileView = false
    @State var userProfile: User? = nil
    
    @ObservedObject var profileReviewsViewModel = ReviewListViewModel()
    
    var body: some View{
        VStack{
            ScrollView{
                VStack{
                    ForEach(profileReviewsViewModel.reviews) { review in
                        ReviewCard(review: review, movieFS: rm.getMovieFS(movieId: "\(review.movieId)"), currentMovie: $currentMovie, showMovieView: $showMovieView, displayName: false, displayTitle: true, showProfileView: $showProfileView, userProfile: $userProfile)

                    }
                }
                .padding()
                .sheet(isPresented: $showMovieView) {
                    if let currentMovie = currentMovie {
                        MovieViewController(movie: currentMovie, isUpcoming: false, showMovieView: $showMovieView)

                            .preferredColorScheme(darkmode ? .dark : .light)
                    }
                }
            }
        }.onAppear(perform: {
            profileReviewsViewModel.getUsersReviews(user: user)
        })
        .sheet(isPresented: $showProfileView) {
            if let userProfile = userProfile {
                ProfileView(user: userProfile)
                    .preferredColorScheme(darkmode ? .dark : .light)
            }
            
        }
    }
}

struct WatchListView: View {
    
    private let movieViewModel: MovieViewModel = MovieViewModel.shared
    let user: User
    @State var movieWatchlist = [Movie]()
    
    var body: some View{
        
        
        VStack{
            
            ScrollView{
                
                ForEach(movieWatchlist, id: \.self) { movie in
                    MovieCardView(movie: movie)
                    
                }
                
            }
        }.onAppear {
            getMovies()
        }
        .padding()
    }
    func getMovies() {
        
        for movies in user.watchlist {
            
            movieViewModel.fetchMovie(id: Int(movies)!) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .failure(let error):
                        print(error)
                    case .success(let movie):
                        movieWatchlist.append(movie)
                    }
                }
            }
            
        }
        
    }
    
}

struct AboutMeView: View {
    
    let user: User
    @State var bio = ""
    
    
    init(user: User) {
        UITextView.appearance().backgroundColor = .clear
        self.user = user
        
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
                        Text(user.bio!)
                            .padding()
                        Spacer()
                    }
                }.padding()
                HStack{
                    Text("Summary of \(user.username)")
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


struct ReviewCardProfileView: View {
    
    let review: Review
    var movieFS: MovieFS?
    @Binding var presentMovie: Movie?
    @Binding var showMovieView : Bool
    
    @State private var isExpanded: Bool = false
    
    private let movieViewModel: MovieViewModel = MovieViewModel.shared
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(Color("secondary-background"))
            HStack(alignment: .top){
                if let movie = movieFS {
                    
                    AsyncImage(url: movie.photoUrl){ image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 100, height: 150, alignment: .center)
                    .border(Color.black, width: 3)
                    .onTapGesture {
                        
                        print("click!")
                        loadMovie(id: movie.id!)
                        showMovieView = true
                        //um.refresh += 1
                    }
                    
                    VStack(alignment: .leading){
                        
                        HStack{
                            Spacer()
                            Text(formatDate(date: review.timestamp))
                                .font(.system(size: 12))
                        }
                        
                        Text(movie.title)
                            .font(.title2)
                            .minimumScaleFactor(0.7)
                            .lineLimit(1)
                        
                        Text("\(review.rating)")
                            .padding(.bottom, 4)
                        
                        Text(review.reviewText)
                            .font(.system(size: 15))
                            .lineLimit(isExpanded ? nil : 4)
                            .onTapGesture {
                                isExpanded.toggle()
                            }
                        Spacer()
                        HStack(alignment: .bottom){
                            Spacer()
                            Text("10000+")
                                .foregroundColor(.red)
                            LikeButton()
                        }
                    }.padding(.leading, 1)
                }
            }
            .padding()
        }
    }
    func loadMovie(id: String) {
        presentMovie = nil
        movieViewModel.fetchMovie(id: Int(id)!) { result in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let movie):
                    presentMovie = movie
                }
            }
        }
    }
}



//private var myReviews = [
//    Review(movieId: 414, username: "Sarah", title: "The Batman", rating: "5/5", reviewText: "Siken film! jag grät, jag skrek, jag belv en helt ny människa!"),
//    Review(movieId: 414906, username: "Sarah", title: "The Duckman", rating: "4/5", reviewText: "Jag gillar ankor så denna film var helt perfekt för mig! Dock så var det ett himla kvackande i biosalongen."),
//    Review(movieId: 272, username: "Sarah", title: "The Birdman", rating: "1/5", reviewText: "Trodde filmen skulle handla om en fågel som ville bli människa, men det var ju helt fel! Den handlar om en man som trodde han var en fågel. Falsk marknadsföring!"),
//    Review(movieId: 406759, username: "Sarah", title: "The Spiderman", rating: "5/5", reviewText: "Jag somnade efter 30min och vaknade strax innan slutet. Bästa tuppluren jag haft på länge! Rekomenderas starkt!")
//]

//private var watchlist = [
//    Movie(id: 1, adult: false, backdropPath: nil, genreIDS: nil, originalLanguage: nil, originalTitle: "spider man", overview: "fasdfdsafasdf", releaseDate: nil, posterPath: nil, popularity: nil, title: "Spooder-Man", video: nil, voteAverage: nil, voteCount: nil)
////    Movie(title: "Spooder-Man", description: "See spider man in one of his gazillion movies"),
////    Movie(title: "Star Wars A New Hope", description: "Small farm boy destoys big buisness"),
////    Movie(title: "Bill. A documentary", description: "From teacher to hero, follow this man on his journey through the world of computers")
//]

struct FriendListView: View{
    @AppStorage("darkmode") private var darkmode = false
    
    @State var showProfileView = false
    @State var userProfile: User?
    
    var user: User
    
    var body: some View {
        
        ScrollView{
            
            ForEach (user.friends, id:\.self) { friend in
                
                let userToDisplay = um.getUser(id: friend)
                VStack {
                    HStack{
                        
                        AsyncImage(url: userToDisplay.photoUrl) { image in
                            image.resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 50, height: 50)
                                .cornerRadius(50)
                        } placeholder: {
                            ProgressView()
                        }
                        
                        VStack(alignment: .leading){
                            Text(userToDisplay.username)
                            
                            // Add number of reviews object
                            Text("Reviews: 25")
                        }
                        
                        Spacer()
                        
                        if um.currentUser!.id! == user.id! {
                            Button {
                                um.removeFriend(id: userToDisplay.id!)
                            } label: {
                                Image(systemName: "trash.circle")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(darkmode ? .red : .black)
                            }
                        }
                    }
                    .padding()
                }
                
                .frame(width: UIScreen.main.bounds.width * 0.9, height: 100)
                .background(Color("secondary-background").clipShape(RoundedRectangle(cornerRadius: 15)))
                .onTapGesture {
                    if user.id == um.currentUser!.id {
                        userProfile = userToDisplay
                        um.refresh += 1
                        showProfileView = true
                    }
                }
            }
            
        }.sheet(isPresented: $showProfileView) {
            if let userProfile = userProfile {
                ProfileView(user: userProfile)
                    .preferredColorScheme(darkmode ? .dark : .light)
            }
        }
    }
    
    
    
}

struct FriendRequestTestView: View {
    @Binding var showProfileSheet: Bool
    @ObservedObject var uq = um
    
    @State var username = ""
    @State var biography = ""
    
    var body: some View {
        VStack{
            
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
            
            Text("Change Username:").padding().padding(.top,40)
            TextField("username", text: $username)
            
            Button {
                if !username.isEmpty {
                    um.changeUsername(username: username)
                    username = ""
                }
            } label: {
                Text("Change username")
            }
        }
        Text("Change Biography:").padding().padding(.top,40)
        
        TextField("biography", text: $biography)
        
        Button {
            if !biography.isEmpty {
                um.updateBiography(biography: biography)
                biography = ""
            }
        } label: {
            Text("Change biography")
        }
    }
}

 
