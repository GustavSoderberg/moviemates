/**
 - Description:
    A loading view is displayed until our app is connected to firebase, then checks if the user is logged in and redirects to the corresponding view.
 
 - Authors:
    Karol Ö
    Oscar K
    Sarah L
    Joakim A
    Denis R
    Gustav S
 
 */

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
                
                TabView(selection: $statusController.selection) {
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
