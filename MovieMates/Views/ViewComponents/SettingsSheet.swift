//
//  SettingsSheet.swift
//  MovieMates
//
//  Created by Sarah Lidberg on 2022-05-09.
//


/**
 - Description: This is the settingSheet that you can find on your ProfieView. Here we can change username, bio, change to light mode and if we want spoilers on or movies.
 
 */

import SwiftUI
import FirebaseAuth

struct SettingsSheet: View {
    @AppStorage("darkmode") private var darkmode = true
    @AppStorage("spoilerCheck") private var spoilerCheck = true
    
    @Binding var showSettingsSheet: Bool
    var user: User
    
    @State var isEditingUsername = false
    @State var isEditingBiography = false
    @State var username = ""
    @State var biography = ""
    @State var index = "friends"
    @State private var showingAlert = false
    
    @State var showCreditSheet = false
    
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
            Toggle(isOn: $darkmode) {
                Text("Change color mode")
            }.padding()
            
            Toggle(isOn: $spoilerCheck) {
                Text("Spoiler Check")
            }.padding()
            Spacer()
            
            Button {
                showCreditSheet = true
            } label: {
                Text("Credits")
            }.sheet(isPresented: $showCreditSheet, content: {
                CreditSheet(showCreditSheet: $showCreditSheet)
            })

            
            Button("Sign out") {
                
                showingAlert = true
            }
            .font(.headline)
            .frame(minWidth: 0, maxWidth: .infinity)
            .frame(height: 40)
            .background(Color("secondary-background"))
            .foregroundColor(.white)
            .cornerRadius(15)
            .padding([.leading, .trailing], 20)
            .padding(.bottom)
            .alert("Are you sure you want to sign out?", isPresented: $showingAlert){
                
                Button("Yes") {
                    try! Auth.auth().signOut()
                    showSettingsSheet = false
                }
                Button("No", role: .cancel) {}
            }
        }
    }
}

