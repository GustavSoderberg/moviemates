//
//  AppDelegate.swift
//  AppDelegate
//
//  Created by Gustav Söderberg on 2022-05-04.
//

import SwiftUI
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
    
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
      
    FirebaseApp.configure()
      
    return true
  }
    
}
