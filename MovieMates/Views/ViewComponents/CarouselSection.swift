//
//  CarouselSection.swift
//  MovieMates
//
//  Created by Denis Rakitin on 2022-05-26.
//

import SwiftUI

struct CarouselSection: View {
    
    @ObservedObject var movieListVM = MovieListViewModel()
    @State var currIndex: Int = 0
    let movieListType: ApiRequestType
    @State var height: CGFloat = 500
    
    var body: some View {
            VStack{
            Carousel(index: $currIndex, items: movieListVM.movies) { movie in
                
                GeometryReader{proxy in
                    
                    let size = proxy.size
                                
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
                    } placeholder: {
                        ProgressView()
                    }
                }
            }
            .frame( height: height, alignment: .top)
            .onAppear(){
                movieListVM.requestMovies(apiReuestType: movieListType)
            }
            .padding(.vertical, 15)
            }
            
        }
    }

//struct CarouselSection_Previews: PreviewProvider {
//    static var previews: some View {
//        CarouselSection()
//    }
//}
