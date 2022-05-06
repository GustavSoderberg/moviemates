//
//  WelcomeView.swift
//  MovieMates
//
//  Created by Gustav Söderberg on 2022-05-02.
//

import SwiftUI
import FirebaseFacebookAuthUI
import FirebaseGoogleAuthUI
import FirebaseOAuthUI

var showLoginViewGlobal = Auth.auth().currentUser == nil ? true : false

struct WelcomeView: View {
    
    @Binding var viewShowing: Status
    @State var showLoginView = showLoginViewGlobal
    
    @State var username = ""
    var body: some View {
        ZStack {
            Color("background")
                .ignoresSafeArea()
            
            VStack {
                
                Text("MovieMate")
                    .font(.largeTitle)
                    .foregroundColor(Color("accent-color"))
                    .padding()
                
                
                Image("clapper-big")
                    .resizable()
                    .foregroundColor(Color.white)
                    .frame(width: 200, height: 200)
                    .padding()
                
                Text("Choose your username")
                    .foregroundColor(Color("accent-color"))
                    .padding()
                
                TextField("ENTER YOUR USERNAME", text: $username).frame(width: 200)
                    .padding()
                
                
                
                Button {
                    if Auth.auth().currentUser != nil && !username.isEmpty {
                        
                        if um.login() {
                            
                            viewShowing = .HomeView
                            
                        }
                        else {
                            
                            um.register(username: username)
                            viewShowing = .HomeView
                            
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
                        print("E: WelcomeView - Failed to sign out user")
                    }
                    
                } label: {
                    HStack {
                        Text("Sign out")
                            .padding()
                    }
                }
            }
            
        }.sheet(isPresented: $showLoginView, onDismiss: {
            
            viewShowing = um.login() ? .HomeView : .WelcomeView
            
        }) {
            
            LoginView(showLoginView: $showLoginView)
            
        }

    }
}

public var screenWidth: CGFloat {
    return UIScreen.main.bounds.width
}

public var screenHeight: CGFloat {
    return UIScreen.main.bounds.height
}

struct LoginView : View {
    
    @Binding var showLoginView : Bool
    @State private var viewState = CGSize(width: 0, height: screenHeight)
    @State private var MainviewState = CGSize.zero
    @ObservedObject var authViewModel = AuthViewModel()
    
    var body : some View {
        ZStack {
            CustomLoginViewController(delegate: authViewModel) { (error) in
                if error == nil {
                    self.status()
                }
            }
        }
    }
    
    func status() {
        self.viewState = CGSize(width: 0, height: 0)
        self.MainviewState = CGSize(width: 0, height: screenHeight)
    }
}

struct CustomLoginViewController : UIViewControllerRepresentable {
    var delegate: FUIAuthDelegate?
    
    var dismiss : (_ error : Error? ) -> Void
    
    func makeCoordinator() -> CustomLoginViewController.Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIViewController
    {
        let authUI = FUIAuth.defaultAuthUI()!
        
        let actionCodeSettings = ActionCodeSettings()
        actionCodeSettings.url = URL(string: "https://example.appspot.com")
        actionCodeSettings.handleCodeInApp = true
        actionCodeSettings.setAndroidPackageName("com.firebase.example", installIfNotAvailable: false, minimumVersion: "12")
        
        let twitterAuthProvider = FUIOAuth.twitterAuthProvider()
//        let facebookAuthProvider = FUIFacebookAuth(authUI: authUI)
        let googleAuthProvider = FUIGoogleAuth(authUI: authUI)
        let githubAuthProvider = FUIOAuth.githubAuthProvider(withAuthUI: authUI)
        
        let authProviders: [FUIAuthProvider] = [
            twitterAuthProvider,
//            facebookAuthProvider,
            googleAuthProvider,
            githubAuthProvider,
        ]
        
        authUI.providers = authProviders
        authUI.delegate = self.delegate
        
        let authViewController = authUI.authViewController()
        
        return authViewController
        
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<CustomLoginViewController>)
    {
        
    }
    
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
            print("\(error) \n Failed to sign in")
        }
        else {
            
            showLoginViewGlobal = false
            
        }
    }
}
