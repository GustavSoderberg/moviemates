/**
 
 - Description:
    The main struct of our app. Here view controllers, enviroment variables are initialized as well as our app delegate.
 
 - Authors:
   Karol Ö
   Oscar K
   Sarah L
   Joakim A
   Denis R
   Gustav S

*/

import SwiftUI
import Firebase

@main
struct MovieMatesApp: App {
    @AppStorage("darkmode") private var darkmode = true
    @StateObject var statusController = StatusController()
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()

                .environment(\.colorScheme, darkmode ? .dark : .light)
                .environmentObject(statusController)

        }
    }
}
