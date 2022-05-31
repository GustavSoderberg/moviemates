/**
 
 - Description:
    The app delegate configures firebase
 
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

class AppDelegate: NSObject, UIApplicationDelegate {
    
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
      
    FirebaseApp.configure()
      
    return true
  }
    
}
