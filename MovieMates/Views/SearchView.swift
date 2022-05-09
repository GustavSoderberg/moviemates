//
//  SearchView.swift
//  MovieMates
//
//  Created by Gustav Söderberg on 2022-05-02.
//

import SwiftUI

struct SearchView: View {
    
    @Binding var text: String

    
    
    @State var index = "movies"
    @State private var isEditing = false
    
    var body: some View {
        ZStack{
            Color("background")
                .ignoresSafeArea()
            VStack{
                
//                HStack{
//
//                    TextField("Search....", text: $text)
//                        .padding(10)
//                        .padding(.horizontal, 25)
//                        .foregroundColor(.white)
//                        .background(Color(.lightGray))
//                        .cornerRadius(10)
//                        .padding(.horizontal, 10 )
//                        .onTapGesture {
//                            self.isEditing = true
//                        }
//                        .overlay(
//                            HStack{
//                                Image(systemName: "magnifyingglass")
//                                    .foregroundColor(.red)
//                                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
//                                    .padding(.leading, 20)
//
//
//                                if isEditing{
//                                    Button(action: {
//                                        self.text = ""
//                                        isEditing = false
//                                    }) {
//                                        Image(systemName: "multiply.circle.fill")
//                                            .foregroundColor(.white)
//                                            .padding(.trailing, 20)
//                                    }
//                                }
//                            }
//                        )
//                }
                
                Picker(selection: $index,
                       label: Text("Reviews"),
                       content: {
                    Text("Movies/Series").tag("movies")
                    Text("Users").tag("users")
                    
                    
                    
                })
                    .padding()
                    .pickerStyle(SegmentedPickerStyle()).foregroundColor(Color.white)
                    .colorMultiply(.red)
                
                switch index {
                case "movies":
                    moviesAndSeriesView()
                case "users":
                    usersView()
                default:
                    moviesAndSeriesView()
                }
            }
        }
    }
}
struct moviesAndSeriesView: View {
    
    @ObservedObject var viewModel = MovieListViewModel()
    
    var body: some View{
        VStack{
            SearchBar(text: $viewModel.searchTerm,
                      onSearchButtonClicked: viewModel.onSearchTapped)
            List(viewModel.movies, id: \.title) { movie in
                MovieCardView(movie: movie)
            }
//            ScrollView{
//                LazyVStack{
//                    ForEach(searchResultsMovies) { result in
//                        MovieCardView(movie: result)
//                    }
//                }
//                .padding()
//            }
        }
    }
}

struct usersView: View {
    
    var body: some View{
        VStack{
            ScrollView{
                LazyVStack{
                    ForEach(searchResultsUsers) { result in
                        UserCardView(user: result)
                    }
                }
                .padding()
            }
        }
    }
}

struct UserCardView: View {
    
    let user: User
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(.gray)
            HStack{
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50, height: 50)
                    .cornerRadius(25)
                VStack(alignment: .leading){
                    Text(user.username)
                }
                Spacer()
            }
            .padding()
        }
    }
}

private var searchResultsUsers = [
    User(documentId: "", authId: "", username: "Jocke", photoUrl: URL(fileURLWithPath: ""), bio: "", friends: [String](), frequests: [String](), themeId: 0),
    User(documentId: "", authId: "", username: "Oscar", photoUrl: URL(fileURLWithPath: ""), bio: "", friends: [String](), frequests: [String](), themeId: 0),
    User(documentId: "", authId: "", username: "Sarah", photoUrl: URL(fileURLWithPath: ""), bio: "", friends: [String](), frequests: [String](), themeId: 0),
    User(documentId: "", authId: "", username: "Gustav", photoUrl: URL(fileURLWithPath: ""), bio: "", friends: [String](), frequests: [String](), themeId: 0)
]

//private var searchResultsMovies = [
////    Movie(title: "Spooder-Man", description: "See spider man in one of his gazillion movies"),
////    Movie(title: "Star Wars A New Hope", description: "Small farm boy destoys big buisness"),
////    Movie(title: "Bill. A documentary", description: "From teacher to hero, follow this man on his journey through the world of computers")
//]


struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(text: .constant(""))
    }
}
