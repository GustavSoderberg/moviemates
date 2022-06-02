/**
 
 - Description:
    Carousel block. Fetch list of movies accroding type of request and then display as block inside of discovery view. Can show array of movies as horizontal carousel or as list
    When you pick a movie from the carousel, you are redirected to ReviewView.
 
 - Authors:
    Karol Ö
    Oscar K
    Sarah L
    Joakim A
    Denis R
    Gustav S
 
*/

import SwiftUI

struct CarouselSection: View {
    
    @AppStorage("darkmode") private var darkmode = true
    
    @StateObject var movieListVM = MovieListViewModel()
    @State var currIndex: Int = 0
    let movieListType: ApiRequestType
    @State var height: CGFloat = 500
    @State var showMovieView = false
    @State var showSheet = false
    @State var currentMovie: Movie? = nil
    @State var isUpcoming : Bool =  false
    
    var body: some View {
        VStack{
            HStack {
                Text(movieListVM.movieListTitle)
                    .font(.title)
                    .fontWeight(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 20)
                
                Button {
                    showSheet = true
                    showMovieView = false
                } label: {
                    HStack {
                        Text("List")
                            .font(.title2)
                            .foregroundColor(Color("text-color1"))
                        Image(systemName: "list.and.film")
                    }
                }
            }
            
            
            ///Loading Carousel view with closure for recreate separate element of list
            Carousel(index: $currIndex, items: movieListVM.movies) { movie in
                
                //get size of  elements inside
                GeometryReader{proxy in
                    
                    let size = proxy.size
                    
                    ZStack {
                        AsyncImage(url: URL(string: "\(BACKDROP_BASE_URL)\(movie.posterPath!)")) { image in
                            image.resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: size.width)
                                .cornerRadius(12)
                                .shadow(radius: 5, x: 5, y: 5)
                                .onAppear(){
                                    if height != size.width * 1.5 {
                                        height = size.width * 1.5
                                    }
                                }
                                .onTapGesture {
                                    movieListVM.currentMovie = movie
                                    if movieListVM.currentMovie != nil {
                                        showSheet = true
                                        showMovieView = true
                                    }
                                }
                        } placeholder: {
                            ProgressView()
                    }
                        //Star button to add movie to watch list directly from movie poster
                        StarButton(currentMovie: movie)
                            .frame( maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                            .padding(15)
                    }
                }
            }
            .frame( height: height, alignment: .top)
            .padding(.vertical, 15)
        }
        .onAppear(){
            //call movie request in case if movies list is empty for prevent get same movie list double when view reinitiate
            if movieListVM.movies.count == 0 {
                movieListVM.requestMovies(apiRequestType: movieListType)
            }
            //Prevent to appear review button
            if movieListType == .upcoming {
                isUpcoming = true
            }
        }
        //Paginate list when user scroll to last movie in carousel
        .onChange(of: currIndex, perform: { index in
            if index == movieListVM.movies.count - 1 && !movieListVM.movies.isEmpty {
                movieListVM.loadMoreContent(apiRequestType: movieListType)
            }
        })
        .sheet(isPresented: $showSheet) {
            // Show sheet of review or movie list depends on user action
            if showMovieView {
                MovieViewController(movie: movieListVM.currentMovie!, isUpcoming: isUpcoming, showMovieView: $showSheet)
                .preferredColorScheme(darkmode ? .dark : .light)
            } else {
                MovieListView(apiRequestType: movieListType, isUpcoming: isUpcoming, showSheet: $showSheet)
                    .preferredColorScheme(darkmode ? .dark : .light)
            }
        }
        .padding(.bottom, 30)
    }
}
