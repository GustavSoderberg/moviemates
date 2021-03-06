/**
 
 - Description:
    We are creating our movie card in this struct. This is the layout for the review that is made from ReviewSheet.
 
 - Authors:
    Karol Ö
    Oscar K
    Sarah L
    Joakim A
    Denis R
    Gustav S
 
 */

import SwiftUI

struct MovieCardView: View {
    @AppStorage("darkmode") private var darkmode = true
    
    let movie: Movie
    @State var showMovieView = false
    @State var isUpcoming: Bool = false
    
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color(GRAY_LIGHT), Color(GRAY_DARK)]), startPoint: .top, endPoint: .bottom)
                .mask(RoundedRectangle(cornerRadius: 25, style: .continuous))
                .shadow(radius: 4)
            HStack(alignment: .top) {
                ZStack{
                    if movie.posterPath != nil {
                        AsyncImage(url: URL(string: "\(BACKDROP_BASE_URL)\(movie.posterPath!)")){ image in
                            image
                                .resizable()
                                .aspectRatio(CGSize(width: 2, height: 3), contentMode: .fit)
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 100, height: 150, alignment: .center)
                        .cornerRadius(5)
                        .overlay(RoundedRectangle(cornerRadius: 5).stroke(.black, lineWidth: 2))
                    } else {
                        Image(systemName: "film")
                            .aspectRatio(CGSize(width: 2, height: 3), contentMode: .fit)
                            .frame(width: 100, height: 150, alignment: .center)
                        
                            .overlay(RoundedRectangle(cornerRadius: 5).stroke(.black, lineWidth: 2))
                    }
                }
                
                VStack(alignment: .leading){
                    Text(movie.title!)
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.bottom, 2)
                        .lineLimit(2)
                        .minimumScaleFactor(0.7)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                    Spacer()
                    Text(movie.overview ?? "")
                        .lineLimit(5)
                        .font(.system(size: 16))
                    
                    Spacer()
                    
                }
                .frame(height: 150)
            }
            .padding()
        }
        .onTapGesture {
            showMovieView = true
        }
        .sheet(isPresented: $showMovieView) {
            MovieViewController(movie: movie, isUpcoming: isUpcoming, showMovieView: $showMovieView)
                .preferredColorScheme(darkmode ? .dark : .light)
        }
    }
}
