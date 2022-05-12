//
//  SettingsSheet.swift
//  MovieMates
//
//  Created by Sarah Lidberg on 2022-05-09.
//

import SwiftUI
import FirebaseAuth

struct SettingsSheet: View {
    
    @Binding var showSettingsSheet: Bool
    var user: User
    @Binding var viewShowing: Status
    
    @State var isEditingUsername = false
    @State var isEditingBiography = false
    @State var username = ""
    @State var biography = ""
    @State var index = "friends"
    
    var body: some View {
        
        VStack{
            
            HStack {
                Button {
                    showSettingsSheet = false
                } label: {
                    Text("Back")
                        .padding()
                }
                
                Spacer()
            }
            
            Spacer()
            
            HStack{
                Text("Change Username")
                Spacer()
            }
            ZStack(){
                RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .fill(Color("secondary-background"))
                    .frame(height: 50)
                
                TextField("username", text: $username)
                    .lineLimit(1)
                    .padding(.leading, 10)
                    .onAppear(perform: {
                        username = user.username
                    })
                    .onTapGesture {
                        isEditingUsername = true
                    }
                
            }
            
            HStack {
                Spacer()
                Button {
                    um.changeUsername(username: username)
                    isEditingUsername = false
                } label: {
                    Image(systemName: "checkmark").font(.title).foregroundColor(isEditingUsername ? .white : .gray)
                }
                Button {
                    username = user.username
                    isEditingUsername = false
                } label: {
                    Image(systemName: "xmark").font(.title).foregroundColor(isEditingUsername ? .white : .gray)
                }
                
            }.padding()
                .padding(.top, -15)
            
            HStack{
                Text("Change Biography")
                Spacer()
            }
            ZStack(alignment: .leading){
                RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .fill(Color("secondary-background"))
                    .frame(minHeight: 100)
                
                TextEditor(text: $biography)
                    .background(Color("secondary-background"))
                    .foregroundColor(Color.white)
                    .frame(minHeight: 100)
                    .cornerRadius(15)
                    .onAppear(perform: {
                        biography = user.bio!
                    })
                    .onTapGesture {
                        isEditingBiography = true
                    }
                    .onAppear {
                        UITextView.appearance().backgroundColor = .clear
                    }
                
            }
            
            HStack {
                Spacer()
                Button {
                    um.updateBiography(biography: biography)
                    isEditingBiography = false
                } label: {
                    Image(systemName: "checkmark").font(.title).foregroundColor(isEditingBiography ? .white : .gray)
                }
                Button {
                    biography = user.bio!
                    isEditingBiography = false
                } label: {
                    Image(systemName: "xmark").font(.title).foregroundColor(isEditingBiography ? .white : .gray)
                }
                
            }.padding()
                .padding(.top, -15)
            
        }.padding()
        VStack {
            
            Spacer()
            
            Button {
                
                try! Auth.auth().signOut()
                showSettingsSheet = false
                
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                        .fill(Color("secondary-background"))
                        .frame(height: 50)
                    Text("SIGN OUT").font(.headline).foregroundColor(.white)
                }
            }
            
            
        }
        .padding()
    }
}
