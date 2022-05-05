//
//  ProfileSheet.swift
//  MovieMates
//
//  Created by Sarah Lidberg on 2022-05-03.
//

import SwiftUI

struct ReviewSheet: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedIndex = 0
    @State var review: String = "Amazing Movie"
    
    init() {
            UITextView.appearance().backgroundColor = .clear
        }
    
    var body: some View {
        Spacer()
        VStack {
            
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 25)
                    .frame(width: 350, height: 200)
                    .foregroundColor(.red)
                
                HStack{
                    VStack{
                        Image("clapper-big")
                            .resizable()
                            .frame(width: 100, height: 100)
                    }.padding()
                    
                    VStack{
                        Text("BATMAN")
                            .foregroundColor(.white)
                            .padding(.bottom, 10)
                        Text("Pick your rating")
                            .foregroundColor(.white)
                        HStack {
                            ForEach(0 ..< 5, id: \.self){i in
                                Image("clapper-big")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                            }
                        }
                        
                    }
                    
                }
            }.padding(.bottom)
            
            
            VStack {
                Text("Write your review:")
                
                TextEditor(text: $review)
                    .background(Color("secondary-background"))
                    .foregroundColor(.white)
                    .frame(width: 350, height: 200)
                    .cornerRadius(10)
        
            }.padding()
            
            
            VStack{
                
                Text("Where did you watch the movie?")
                
                
                Picker(selection: $selectedIndex, label: Text("Question one")){
                    Text("Home").tag(1)
                    Text("Cinema").tag(2)
                }.pickerStyle(SegmentedPickerStyle())
                    .frame(width: 300)
                
                Text("How did you watch the movie?")
                
                Picker(selection: $selectedIndex, label: Text("Question one")){
                    Text("Alone").tag(1)
                    Text("With friends").tag(2)
                }.pickerStyle(SegmentedPickerStyle())
                    .frame(width: 300)
                
            }
            
            Spacer()
            
            HStack {
                Button {
                    print("Cancel")
                } label: {
                    Text("Cancel")
                }
                .frame(width: 100, height: 50)
                .foregroundColor(.white)
                .background(Color.red)
                
                Button {
                    print("Save")
                } label: {
                    Text("Save")
                }
                .frame(width: 100, height: 50)
                .foregroundColor(.white)
                .background(Color.green)
                
                
            }
            
            Spacer()
        }
        
    }
}



struct ProfileSheet_Previews: PreviewProvider {
    static var previews: some View {
        ReviewSheet()
    }
}
