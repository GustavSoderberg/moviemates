//
//  WelcomeView.swift
//  MovieMates
//
//  Created by Gustav Söderberg on 2022-05-02.
//

import SwiftUI
import FirebaseGoogleAuthUI
import FirebaseOAuthUI

var showLoginViewGlobal = Auth.auth().currentUser == nil ? true : false

struct WelcomeView: View {
    @AppStorage("darkmode") private var darkmode = true
    @EnvironmentObject var statusController: StatusController
    
    @State var showLoginView = showLoginViewGlobal
    var welcomeClapperArray = [Color("welcome-clapper-top") , Color("welcome-clapper-bottom")]
    var backgroundView: AnyView = AnyView(Color.white)
    
    @State var username = ""
    var body: some View {
        ZStack {
            Color("background")
                .ignoresSafeArea()
                .onAppear {
                    if Auth.auth().currentUser == nil { showLoginView = true }
                }
            
            VStack {
                
                Text("MovieMate")
                    .font(.largeTitle)
                    .foregroundColor(Color("welcome-title"))
                    .padding()
                
                LinearGradient(gradient: Gradient(colors: welcomeClapperArray), startPoint: .top, endPoint: .bottom)
                            .mask(Image("clapper-big")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            )
                            .frame(width: 200, height: 200)
                            .shadow(radius: 10)
                
                Text("Choose your username")
                    .foregroundColor(Color("welcome-title"))
                    .padding()
                
                TextField("ENTER YOUR USERNAME", text: $username).frame(width: 200)
                    .padding()
                
                Button {
                    if Auth.auth().currentUser != nil && !username.isEmpty {
                        if um.login() {
                            statusController.viewShowing = .HomeView
                        } else {
                            um.register(username: username)
                            statusController.viewShowing = .HomeView
                        }
                    }
                } label: {
                    HStack {
                        Text("Continue")
                        Image(systemName: "arrow.forward")
                    }
                    .padding()
                }
                
                Button {
                    do {
                        try Auth.auth().signOut()
                        showLoginView = true
                        print("Successfully signed out user")
                    }
                    catch {
                        print("E: WelcomeView - WelcomeView() Failed to sign out user")
                    }
                    
                } label: {
                    HStack {
                        Text("Sign out")
                            .padding()
                    }
                }
            }
            
        }.sheet(isPresented: $showLoginView, onDismiss: {
            
            statusController.viewShowing = um.login() ? .HomeView : .WelcomeView
            
        }) {
            
            LoginView(showLoginView: $showLoginView)
                .preferredColorScheme(darkmode ? .dark : .light)
                .ignoresSafeArea()
        }
        .environmentObject(statusController)

    }
}

struct LoginView : View {
    
    @Binding var showLoginView : Bool
    @ObservedObject var authViewModel = AuthViewModel()
    
    var body : some View {
        CustomLoginViewController(delegate: authViewModel)
    }
}

struct CustomLoginViewController : UIViewControllerRepresentable {
    
    var delegate: FUIAuthDelegate?
    
    func makeCoordinator() -> CustomLoginViewController.Coordinator {
        
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        
        let authUI = FUIAuth.defaultAuthUI()!
        
        let twitterAuthProvider = FUIOAuth.twitterAuthProvider(withAuthUI: authUI)
        let githubAuthProvider = FUIOAuth.githubAuthProvider(withAuthUI: authUI)
        let googleAuthProvider = FUIGoogleAuth(authUI: authUI)
        
        let authProviders: [FUIAuthProvider] = [
            twitterAuthProvider,
            googleAuthProvider,
            githubAuthProvider,
        ]
        
        authUI.providers = authProviders
        authUI.delegate = self.delegate
        
        let authViewController = authUI.authViewController()
        
        return authViewController
        
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<CustomLoginViewController>){}
    
    class Coordinator: NSObject {
        
        var parent: CustomLoginViewController
        
        init(_ customLoginViewController : CustomLoginViewController) {
            self.parent = customLoginViewController
        }
    }
}

class AuthViewModel: NSObject, ObservableObject, FUIAuthDelegate {
    
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, url: URL?, error: Error?) {
        if let error = error {
            print("E: WelcomeView - AuthViewModel() Failed to sign in \n \(error)")
        }
        else {
            showLoginViewGlobal = false
        }
    }
}
 
