//
//  CarouselSection.swift
//  MovieMates
//
//  Created by Denis Rakitin on 2022-05-26.
//

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

//                Text("List > ")
//                    .font(.title3)
//                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            
            Carousel(index: $currIndex, items: movieListVM.movies) { movie in
                
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
            if movieListVM.movies.count == 0 {
                movieListVM.requestMovies(apiReuestType: movieListType)
            }
            if movieListType == .upcoming {
                isUpcoming = true
            }
        }
        .onChange(of: currIndex, perform: { index in
            if index == movieListVM.movies.count - 1 && !movieListVM.movies.isEmpty {
                movieListVM.loadMoreContet(apiRequestType: movieListType)
            }
        })
        .sheet(isPresented: $showSheet) {
            
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

//struct CarouselSection_Previews: PreviewProvider {
//    static var previews: some View {
//        CarouselSection()
//    }
//}
