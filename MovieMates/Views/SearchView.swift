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
                
                Picker(selection: $index,
                       label: Text("Reviews"),
                       content: {
                    Text("Movies/Series").tag("movies")
                    Text("Users").tag("users")
                })
                    .padding()
                    .pickerStyle(SegmentedPickerStyle()).foregroundColor(Color.white)
                    .colorMultiply(Color("accent-color"))
                
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
    @State var infoText = "Type to search"
    
    
    var body: some View{
        VStack{
            SearchBar(text: $viewModel.searchTerm,
                      onSearchButtonClicked: viewModel.onSearchTapped, onCancelButtonClicked: viewModel.onCancelTapped)
            
            if viewModel.searchTerm.isEmpty {
                SearchViewInfo(infoText: $viewModel.infoText)
                    .frame(maxHeight: .infinity)
            } else if viewModel.movies.isEmpty && !viewModel.searchTerm.isEmpty {
                SearchViewInfo(infoText: $viewModel.infoText)
                    .frame(maxHeight: .infinity)
            } else {
                List(viewModel.movies, id: \.id) { movie in
                    MovieCardView(movie: movie).listRowBackground(Color("background"))
                        .onAppear(){
                            viewModel.loadMoreContent(currentItem: movie, apiRequestType: .searchByTerm)
                        }
                }.listStyle(.plain)
                    
                .onAppear {
                    UITableView.appearance().separatorStyle = .none
                    UITableView.appearance().separatorColor = UIColor(Color("background"))
                    UITableViewCell.appearance().backgroundColor = UIColor(Color("background"))
                    UITableView.appearance().backgroundColor = UIColor(Color("background"))
                }
            }
        }
    }
}

struct usersView: View {
    @AppStorage("darkmode") private var darkmode = true
    
    
    @ObservedObject var oum = um
    @State var showProfileView = false
    @State var index1 = 0
    @State var searchText = ""
    @State var templateText = "Type to search"
    
    var body: some View{
        
        VStack{
            SearchBar(text: $searchText)
            Spacer()
            if searchText.isEmpty {
                SearchViewInfo(infoText: $templateText)
                    .frame(maxHeight: .infinity)
            }
            else {
                ScrollView{
                    VStack{
                        ForEach(Array(zip(oum.listOfUsers.indices, oum.listOfUsers)), id: \.0) { index, user in
                            
                            if user.id != um.currentUser!.id {
                                if user.username.lowercased().contains(searchText.lowercased())  {
                                    
                                    Button {
                                        index1 = index
                                        um.refresh += 1
                                        
                                        showProfileView = true
                                    } label: {
                                        UserCardView(user: user)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                    }
                    .padding()
                    
                }
            }
            
        }.sheet(isPresented: $showProfileView) {
            ProfileView(user: oum.listOfUsers[self.index1])
                .preferredColorScheme(darkmode ? .dark : .light)
        }
    }
}

struct UserCardView: View {
    
    let user: User
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(Color("secondary-background"))
            HStack{
                AsyncImage(url: user.photoUrl) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 50, height: 50)
                        .cornerRadius(50)
                } placeholder: {
                    ProgressView()
                }
                VStack(alignment: .leading){
                    Text(user.username)
                }
                Spacer()
            }
            .padding()
        }
    }
}
