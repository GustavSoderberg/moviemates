//
//  SettingsSheet.swift
//  MovieMates
//
//  Created by Sarah Lidberg on 2022-05-09.
//

import SwiftUI
import FirebaseAuth

struct SettingsSheet: View {
    @AppStorage("darkmode") private var darkmode = true
    
    @Binding var showSettingsSheet: Bool
    var user: User
    
    
    @State var isEditingUsername = false
    @State var isEditingBiography = false
    @State var username = ""
    @State var biography = ""
    @State var index = "friends"
    @State private var showingAlert = false
    
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
                
                Button {
                    um.changeUsername(username: username)
                    um.updateBiography(biography: biography)
                    
                    isEditingUsername = false
                    isEditingBiography = false
                    
                    showSettingsSheet = false
                } label: {
                    Text("Save")
                }
                
                
                
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
            
            
        }.padding()
        VStack {
            HStack{
                Text("Change Theme")
                Spacer()
            }
            
            Picker("Mode",selection: $darkmode) {
                Text("Light")
                    .tag(false)
                Text("Dark")
                    .tag(true)
            }.pickerStyle(SegmentedPickerStyle())
            
            Spacer()
            
            Button("Sign out") {
                
                showingAlert = true
//
            }
            .font(.headline)
            .background(Color("secondary-background"))
            .foregroundColor(.white)
            .cornerRadius(15)
            .frame(minWidth: 0, maxWidth: .infinity)
            .alert("Are you sure you want to sign out?", isPresented: $showingAlert){
                
                Button("Yes") {
                    try! Auth.auth().signOut()
                    showSettingsSheet = false
                }
                Button("No", role: .cancel) {}
            }
//        message: {
//                ZStack {
//                    RoundedRectangle(cornerRadius: 15, style: .continuous)
//                        .fill(Color("secondary-background"))
//                        .frame(height: 50)
//                    Text("SIGN OUT").font(.headline).foregroundColor(.white)
//                }
//            }
            
            
        }
    }
}

