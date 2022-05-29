//
//  MovieListView.swift
//  MovieMates
//
//  Created by Denis Rakitin on 2022-05-28.
//

import SwiftUI

struct MovieListView: View {
    
    @StateObject var movieListVM = MovieListViewModel()
    let apiRequestType: ApiRequestType
    let isUpcoming: Bool
    
    //    @Binding var movieList: [Movie]
    //    let title: String
    //    @Binding var isUpcoming: Bool
    @Binding var showSheet: Bool
    
    var body: some View {
        NavigationView {
            ScrollView{
                VStack {
                    ForEach(movieListVM.movies, id: \.self) { movie in
                        MovieCardView(movie: movie, isUpcoming: isUpcoming)
                        //                    .onAppear(){
                        //                        movieListVM.loadMoreContent(currentItem: movie, apiRequestType: apiRequestType)
                        //                    }
                    }
                    Button {
                        movieListVM.loadMoreContet(apiRequestType: apiRequestType)
                    } label: {
                        Text("LOAD MORE")
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .font(.system(size: 18))
                            .padding()
                            .foregroundColor(.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(Color.white, lineWidth: 2)
                            )
                    }
                    .background(Color("accent-color"))
                    .cornerRadius(25)
                    .padding(10)
                    
                }
            }
            .onAppear(){
                movieListVM.requestMovies(apiReuestType: apiRequestType)
            }
            .navigationTitle(movieListVM.movieListTitle.uppercased())
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showSheet = false
                    } label: {
                        Image(systemName: "arrow.backward")
                    }
                }
            }
        }
    }
}

//struct MovieListView_Previews: PreviewProvider {
//    static var previews: some View {
//        MovieListView()
//    }
//}
