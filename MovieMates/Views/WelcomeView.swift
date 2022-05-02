//
//  WelcomeView.swift
//  MovieMates
//
//  Created by Gustav Söderberg on 2022-05-02.
//

import SwiftUI

struct WelcomeView: View {
    
    @Binding var viewShowing: Status
    
    var body: some View {
        Text("Welcome View")
        
        Button {
            viewShowing = .HomeView
        } label: {
            Text("Login")
        }

    }
}

//struct WelcomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        WelcomeView()
//    }
//}
