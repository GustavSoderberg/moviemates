//
//  FriendsSheet.swift
//  MovieMates
//
//  Created by Sarah Lidberg on 2022-05-10.
//

/**
 - Description: On ProfileView, this notificationSheet is used on when you have pending friend request.
 
 */

import SwiftUI

struct NotificationSheet: View {
    
    @Binding var showNotificationSheet: Bool
    @ObservedObject var oum = um
    
    var body: some View {
        
        
        VStack{
            Text("Notifications")
                .font(.title2)
                .foregroundColor(.green)
                .padding(.top, 40)
                .padding(.bottom, 20)
            
            Divider()
            
            if oum.currentUser!.frequests.isEmpty {
                Spacer()
                Text("You have no new notifications")
            }
            else {
                ForEach(oum.currentUser!.frequests, id: \.self) { request in
                    
                    mockupNotification(user: um.getUser(id: request))
                        .padding()
                    
                }
            }
            Spacer()
        }
    }
}

struct mockupNotification : View{
    
    var user: User
    
    var body: some View {
        
        VStack{
            Text("\(user.username) wants to be your friend ")
            HStack() {
                Button {
                    um.manageFriendRequests(forId: user.id!, accept: true)
                } label: {
                    Image(systemName: "checkmark")
                }.foregroundColor(.green)
                
                
                Button {
                    um.manageFriendRequests(forId: user.id!, accept: false)
                } label: {
                    Image(systemName: "nosign")
                }.foregroundColor(.red)
                    .padding(.leading)
            }.padding()
        }
    }
}