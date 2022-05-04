//
//  ProfileView.swift
//  MovieMates
//
//  Created by Gustav Söderberg on 2022-05-02.
//

import SwiftUI
import FirebaseAuth


struct ProfileView: View {
    
    @State var index = "reviews"
    @State private var showingSheet = false
    
    
    var body: some View {
        
        VStack{
            
            ZStack{
                
                Text(um.currentUser!.username)
                    .font(.largeTitle)
                    .lineLimit(1)
                    .frame(width: 250)
                    
                HStack{
                    Spacer()
                
                Button {
                    showingSheet = true
                } label: {
                    Image(systemName: "slider.horizontal.3")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .padding(.trailing, 30)
                }.sheet(isPresented: $showingSheet) {
                    SettingSheetView(showProfileSheet: $showingSheet)
                    
                }
                
            }
            }
            Spacer()
            AsyncImage(url: um.currentUser!.photoUrl) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .cornerRadius(50)
            } placeholder: {
                ProgressView()
            }
            Spacer()
            
                
                Picker(selection: $index,
                       label: Text("Reviews"),
                       content: {
                    Text("Reviews").tag("reviews")
                    Text("Watchlist").tag("watchlist")
                    Text("About").tag("about")
                    
                })
                    .padding()
                    .pickerStyle(SegmentedPickerStyle())
                
            
            switch index {
            case "reviews":
                UserReviewView()
            case "watchlist":
                WatchListView()
            case "about":
                AboutMeView()
            default:
                UserReviewView()
            }
            
            Spacer()
        }
    }
}


struct UserReviewView: View {
    
    var body: some View{
        VStack{
            Text("Hej min favoritfilm är Batman!!")
            
        }
        
    }
}
struct WatchListView: View {
    
    var body: some View{
        VStack{
            Text("Jag vill se den nya Dr Strange!!")
            
        }
        
    }
}
struct AboutMeView: View {
    
    var body: some View{
        VStack{
            Text("Tjo! Jag gillar att kolla på film!!")
            
        }
        
    }
}

struct SettingSheetView: View {
    @Binding var showProfileSheet: Bool
    
    var body: some View {
        Button("Press to dismiss") {
            showProfileSheet = false
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

