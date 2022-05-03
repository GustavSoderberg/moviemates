//
//  WelcomeView.swift
//  MovieMates
//
//  Created by Gustav Söderberg on 2022-05-02.
//

import SwiftUI

struct WelcomeView: View {
    
    @Binding var viewShowing: Status
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
                    viewShowing = .HomeView
                } label: {
                    HStack {
                        Image(systemName: "checkmark")
                        Text("Login")
                            .padding()
                    }
                }
                
            }
            
        }

    }
}

//struct WelcomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        WelcomeView()
//    }
//}
