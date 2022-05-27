//
//  DicoverView.swift
//  MovieMates
//
//  Created by Denis Rakitin on 2022-05-26.
//

import SwiftUI


struct DicoverView: View {
    
    @AppStorage("darkmode") private var darkmode = true
    
    @ObservedObject var movieListVMPopular = MovieListViewModel()
    @ObservedObject var movieListVMUpcoming = MovieListViewModel()
    @State var currIndexPop: Int = 0
    @State var currIndexUp: Int = 0
    @State var showMovieView = false
    @State var currentMovie: Movie? = nil
    @State var isUpcoming:Bool =  false
    @State var height:CGFloat
    
    var body: some View {
        ScrollView(.vertical){
            VStack {
                Text("Popular")
                    .font(.title)
                    .fontWeight(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                    Carousel(index: $currIndexPop, items: movieListVMPopular.movies) { movie in

                            GeometryReader{proxy in

                                let size = proxy.size

                                ZStack {
                                    AsyncImage(url: URL(string: "\(BACKDROP_BASE_URL)\(movie.posterPath!)")) { image in
                                          image.resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: size.width)
                                            .cornerRadius(12)
                                            .onAppear(){
                                                if height != size.width * 1.5 {
                                                    height = size.width * 1.5
                                                }
                                            }
                                            .onTapGesture {
                                                currentMovie = movie
                                                showMovieView = true
                                                isUpcoming = false
                                            }
                                    } placeholder: {
                                        ProgressView()
                                }
                                    LikeButton()
                                        .frame( maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                                }
                            }

                        }
                        .onAppear(){
                            movieListVMPopular.requestMovies(apiReuestType: .popular)
                        
                        }
                        .onChange(of: showMovieView, perform: { newValue in
                            if movieListVMPopular.movies.count == 0 && showMovieView == false {
                                movieListVMPopular.requestMovies(apiReuestType: .popular)
                            }
                        })
                        .onChange(of: currIndexPop, perform: { index in
                            if index == movieListVMPopular.movies.count - 1 {
                                movieListVMPopular.loadMoreContet(apiRequestType: .popular)
                            }
                        })

                    .frame(height: height)
                
                Spacer(minLength: 30)
                    .padding(10)
                
                Text("Upcoming")
                    .font(.title)
                    .fontWeight(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Carousel(index: $currIndexUp, items: movieListVMUpcoming.movies) { movie in

                    GeometryReader{proxy in

                        let size = proxy.size

                        AsyncImage(url: URL(string: "\(BACKDROP_BASE_URL)\(movie.posterPath!)")) { image in
                              image.resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: size.width)
                                .cornerRadius(12)
                                .onTapGesture {
                                    currentMovie = movie
                                    showMovieView = true
                                    isUpcoming = true
                                }
                        } placeholder: {
                            ProgressView()
                        }
                    }
                }
                .onAppear(){
                    movieListVMUpcoming.requestMovies(apiReuestType: .upcoming)
                }
                .onChange(of: showMovieView, perform: { newValue in
                    if movieListVMUpcoming.movies.count == 0 && showMovieView == false {
                        movieListVMUpcoming.requestMovies(apiReuestType: .upcoming)
                    }
                })
                .onChange(of: currIndexUp, perform: { index in
                    if index == movieListVMUpcoming.movies.count - 1 {
                        movieListVMUpcoming.loadMoreContet(apiRequestType: .upcoming)
                    }
                })
                .frame(height: height)

            }
            .sheet(isPresented: $showMovieView) {

                if let currentMovie = currentMovie {
                    MovieViewController(movie: currentMovie, isUpcoming: isUpcoming, showMovieView: $showMovieView)

                        .preferredColorScheme(darkmode ? .dark : .light)
                }
            }
        }
        .frame(maxHeight: .infinity)
    }
}

struct DicoverView_Previews: PreviewProvider {
    static var previews: some View {
        DicoverView( height: 500)
    }
}
