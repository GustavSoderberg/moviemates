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
                    .font(.title2)
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
                
            HStack{
                Text("Change Biography")
                    .font(.title2)
                Spacer()
            }
            ZStack(){
                RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .fill(Color("secondary-background"))
                    .frame(minHeight: 100)
                
                TextField("username", text: $biography)
                    .padding(.leading, 10)
                    .onAppear(perform: {
                        biography = user.bio!
                    })
                    .onTapGesture {
                        isEditingBiography = true
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
