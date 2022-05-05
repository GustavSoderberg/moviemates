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
                
                HStack{
                    
                    TextField("Search....", text: $text)
                        .padding(10)
                        .padding(.horizontal, 25)
                        .foregroundColor(.white)
                        .background(Color(.lightGray))
                        .cornerRadius(10)
                        .padding(.horizontal, 10 )
                        .onTapGesture {
                            self.isEditing = true
                        }
                        .overlay(
                            HStack{
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.red)
                                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                    .padding(.leading, 10)
                                
                                
                                if isEditing{
                                    Button(action: {
                                        self.text = ""
                                    }) {
                                        Image(systemName: "multiply.circle.fill")
                                            .foregroundColor(.white)
                                            .padding(.trailing, 10)
                                    }
                                }
                            }
                        )
                    if isEditing {
                        Button(action: {
                            self.isEditing = false
                            self.text = ""
                            
                        }) {
                            Text("Cancel")
                        }
                        .padding(.trailing, 10)
                        .transition(.move(edge: .trailing))
                        .animation(.default)
                    }
                
                }
                
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
    
    var body: some View{
        VStack{
            ScrollView{
                LazyVStack{
                    ForEach(searchResults) { result in
                        MovieCardView(movie: result)
                    }
                }
                .padding()
            }
        }
        
    }
}

struct usersView: View {
    
    var body: some View{
        VStack{
            Text("hej hej här ska Users visas")
        }
        
    }
}

private var searchResults = [
    Movie(title: "Spooder-Man", description: "See spider man in one of his gazillion movies"),
    Movie(title: "Star Wars A New Hope", description: "Small farm boy destoys big buisness"),
    Movie(title: "Bill. A documentary", description: "From teacher to hero, follow this man on his journey through the world of computers")
]


struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(text: .constant(""))
    }
}
