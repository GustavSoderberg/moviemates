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

enum Status {
    case Loading, WelcomeView, HomeView
}

struct ContentView: View {
    
    @ObservedObject var uw = um
    @State var viewShowing: Status = .Loading
    @State private var selection = 2
    @State var text = ""
    
    init() {
        
        fm.listenToFirestore()
        
    }
    
    var body: some View {
        
        
        VStack {
            
            
            
            switch self.viewShowing {
                
            case .Loading:
                
                
                ZStack{
                    Color("background")
                        .ignoresSafeArea()
                    if um.isLoading {
                        
                        ProgressView("Loading")
                        
                    }
                    else {
                        
                        ProgressView("Checking if currentUser exists")
                            .onAppear {
                                if um.currentUser != nil {
                                    viewShowing = .HomeView
                                }
                                else {
                                    viewShowing = .WelcomeView
                                }
                                
                            }
                        
                    }
                }
                
            case .WelcomeView:
                WelcomeView(viewShowing: $viewShowing)
                
            case .HomeView:
                
                TabView(selection: $selection) {
                    ProfileView(user: um.currentUser!, viewShowing: $viewShowing)
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
                    
                    SearchView(text: $text, viewShowing: $viewShowing)
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
