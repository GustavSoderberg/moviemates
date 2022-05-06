//
//  ContentView.swift
//  MovieMates
//
//  Created by Gustav Söderberg on 2022-05-02.
//

import SwiftUI
import FirebaseAuth

//Global singleton
var um = UserManager()
var fm = FirestoreManager()

enum Status {
    case WelcomeView, HomeView
}

struct ContentView: View {
    
    @ObservedObject var uw = um
    @State var viewShowing: Status = Auth.auth().currentUser != nil ? .HomeView : .WelcomeView
    @State var text = ""
    
    init() {
        
        fm.listenToFirestore()
        
    }
    
    var body: some View {
        
        if um.isLoading {
            
            ProgressView()
            
        }
        
        else {
            VStack {
                switch self.viewShowing {
                    
                case .WelcomeView:
                        WelcomeView(viewShowing: $viewShowing)
                    
                case .HomeView:
                    
                    TabView {
                        ProfileView()
                            .tabItem {
                                Image(systemName: "person.fill")
                                Text("Profile")
                            }
                        HomeView()
                            .tabItem {
                                Image(systemName: "house")
                                Text("Home")
                            }
                        SearchView(text: $text)
                            .tabItem {
                                Image(systemName: "magnifyingglass")
                                Text("Search")
                            }
                    }
                }
            }
        }
    }
}
