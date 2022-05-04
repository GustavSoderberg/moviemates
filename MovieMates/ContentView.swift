//
//  ContentView.swift
//  MovieMates
//
//  Created by Gustav Söderberg on 2022-05-02.
//

import SwiftUI

enum Status {
    case WelcomeView, HomeView
}

struct ContentView: View {
    
    @State var viewShowing: Status = .WelcomeView
    @State var text = ""
    
    var body: some View {
        
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
