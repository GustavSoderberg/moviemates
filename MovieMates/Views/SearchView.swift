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
                                        isEditing = false
                                    }) {
                                        Image(systemName: "multiply.circle.fill")
                                            .foregroundColor(.white)
                                            .padding(.trailing, 10)
                                    }
                                }
                            }
                        )
                
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
            Text("Här ska filmer visas")
            
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


struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(text: .constant(""))
    }
}
