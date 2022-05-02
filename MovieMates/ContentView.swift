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

struct SwiftUISwitchView: View {
    
    @State var viewShowing: Status = .WelcomeView
    
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
                    SearchView()
                        .tabItem {
                            Image(systemName: "magnifyingglass")
                            Text("Search")
                        }
                }
                
            }
        }
    }
}
