//
//  FriendsSheet.swift
//  MovieMates
//
//  Created by Sarah Lidberg on 2022-05-10.
//

import SwiftUI

struct NotificationSheet: View {
    
    @Binding var showNotificationSheet: Bool
    
    var body: some View {
        
        
        VStack{
            Text("Notifications")
                .font(.title2)
                .foregroundColor(.green)
                .padding(.top, 40)
                .padding(.bottom, 20)
            
            Divider()
            
            mockupNotification()
                .padding()
            mockupNotification()
                .padding()
            mockupNotification()
                .padding()
            
            Spacer()
        }
        
    }
    
}




struct mockupNotification : View{
    
    var body: some View {
        
        
        
        HStack{
            Text("Gustav wants to be your friend: ")
            Button {
                print("accept friend")
            } label: {
                Image(systemName: "checkmark")
            }.foregroundColor(.green)
            
            
            Button {
                print("Decline friend")
            } label: {
                Image(systemName: "nosign")
            }.foregroundColor(.red)
                .padding(.leading)
            
            
        }.padding(.trailing)
        
    }
    
}


//struct FriendsSheet_Previews: PreviewProvider {
//    static var previews: some View {
//        NotificationSheet(showNotificationSheet: true)
//    }
//}
