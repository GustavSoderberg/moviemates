/**
 - Description:
 Our main view consists of three views displayed in tabs
 
 ProfileView:
 The first is for the profileView where information is about the current user.  In this view we can see our own reviews that we have made, our watchlist, friendlist and current user information.  In the information tab we can view a user's bio and see their statistics (including yourself).
 
 HomeView:
 Second is the homeView where we have three tabs. Here we can find reviews that friends have made but also a tab where reviews from the whole app can be shown.
 There's also a Discover view with popular, upcoming, cinema and top rated movies displayed in a coverflow or a list (whichever you prefer)
 
 SearchView:
 The third tab is searchView, where you can search for movies/series as well as a user you would like to view.
 
 
 - Authors:
    Karol Ö
    Oscar K
    Sarah L
    Joakim A
    Denis R
    Gustav S
 
 */

import SwiftUI

struct SearchView: View {
    @EnvironmentObject var statusController: StatusController
    
    @Binding var text: String
    
    @State var index = "movies"
    @State private var isEditing = false
    
    var body: some View {
        ZStack{
            Color("background")
                .ignoresSafeArea()
            VStack{
                
                Picker(selection: $statusController.searchIndex,
                       label: Text("Reviews"),
                       content: {
                    Text("Movies/Series").tag("movies")
                    Text("Users").tag("users")
                })
                .padding()
                .pickerStyle(SegmentedPickerStyle()).foregroundColor(Color.white)
                .colorMultiply(Color("accent-color"))
                
                switch statusController.searchIndex {
                case "movies":
                    moviesAndSeriesView()
                case "users":
                    searchUserView()
                default:
                    moviesAndSeriesView()
                }
            }
        }
    }
}
/**
 
 - Description: This is where we draw our view for the SearchView. Here we check if you put a search word or not, if the search quary is found we make card views of the results. 
 */
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

/**
 - Description: Here we can search for a user.  We loop through a list of users and return the searched quary.
 */
struct searchUserView: View {
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
            ScrollView{
                VStack{
                    if searchText.isEmpty {
                        ForEach(Array(zip(oum.listOfUsers.indices, oum.listOfUsers)), id: \.0) { index, user in
                            if user.id != um.currentUser!.id {
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
                    } else {
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
                }.sheet(isPresented: $showProfileView) {
                    ProfileView(user: oum.listOfUsers[self.index1])
                        .preferredColorScheme(darkmode ? .dark : .light)
                }
            }
            .padding()
        }
    }
}
/**
 
 - Description: This is the layout of how a card is going to look like if you search for a user. It is used in the struct above.
 */
struct UserCardView: View {
    
    let user: User
    
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color(GRAY_LIGHT), Color(GRAY_DARK)]), startPoint: .top, endPoint: .bottom)
                .mask(RoundedRectangle(cornerRadius: 25, style: .continuous))
                .shadow(radius: 4)
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
