//
//  ContentView.swift
//  MovieMates
//
//  Created by Gustav Söderberg on 2022-05-02.
//

import SwiftUI
import FirebaseAuth

//Global singleton instances
var um = UserManager()
var fm = FirestoreManager()
var rm = ReviewManager()


struct ContentView: View {
    
    @EnvironmentObject var statusController: StatusController
    @ObservedObject var uw = um
    
    @State var viewShowing: Status = .Loading
    @State private var selection = 2
    @State var text = ""
    
    init() {
        fm.listenToFirestore()
    }
    
    var body: some View {
        
        VStack {
            
            switch statusController.viewShowing {
                
            case .Loading:
                ZStack{
                    Color("background")
                        .ignoresSafeArea()
                    if um.isLoading {
                        ProgressView("Loading")
                    } else {
                        ProgressView("Checking if currentUser exists")
                            .onAppear {
                                if um.currentUser != nil {
                                    statusController.viewShowing = .HomeView
                                } else {
                                    statusController.viewShowing = .WelcomeView
                                }
                            }
                    }
                }
                
            case .WelcomeView:
                WelcomeView()
                
            case .HomeView:
                
                TabView(selection: $selection) {
                    ProfileView(user: um.currentUser!)
                        .tabItem {
                            Image(systemName: "person.fill")
                            Text("Profile")
                        }
                        .tag(1)
                    HomeView()
                        .tabItem {
                            Image(systemName: "house")
                            Text("Home")
                        }
                        .tag(2)
                    SearchView(text: $text)
                        .tabItem {
                            Image(systemName: "magnifyingglass")
                            Text("Search")
                        }
                        .tag(3)
                }
            }
        }
    } 
}
