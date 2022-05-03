//
//  ProfileView.swift
//  MovieMates
//
//  Created by Gustav Söderberg on 2022-05-02.
//

import SwiftUI



struct ProfileView: View {
    
    @State var index = ""
    @State private var showingSheet = false
   
    
    
    var body: some View {
        
        VStack{
            
            HStack{
                
            
             Text("USERNAME")
                .font(.largeTitle)
                
                Button {
                    showingSheet.toggle()
                } label: {
                    Image(systemName: "slider.horizontal.3")
                        .resizable()
                        .frame(width: 25, height: 25)
                }.sheet(isPresented: $showingSheet) {
                    SheetView()

            }
            }
            Spacer()
            
            Image(systemName: "person")
                .resizable()
                    .frame(width: 50.0, height: 50.0)
            
        Spacer()
        HStack{
            
            Picker(selection: $index,
                   label: Text("Gender"),
                   content: {
                Text("Reviews").tag("reviews")
                Text("Wishlist").tag("wishlist")
                Text("About").tag("about")
                
            })
                .padding()
                .pickerStyle(SegmentedPickerStyle())
            
        }
        
            Spacer()
    }
    }
}


struct SheetView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        Button("Press to dismiss") {
            dismiss()
        }
        .font(.title)
        .padding()
        .background(Color.black)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}

