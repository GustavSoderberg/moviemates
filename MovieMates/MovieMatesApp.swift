//
//  MovieMatesApp.swift
//  MovieMates
//
//  Created by Gustav Söderberg on 2022-05-02.
//

import SwiftUI
import Firebase

@main
struct MovieMatesApp: App {
    @AppStorage("darkmode") private var darkmode = true
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()

                .environment(\.colorScheme, darkmode ? .dark : .light)

        }
    }
}
