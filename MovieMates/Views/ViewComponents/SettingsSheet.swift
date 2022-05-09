//
//  SettingsSheet.swift
//  MovieMates
//
//  Created by Sarah Lidberg on 2022-05-09.
//

import SwiftUI

struct SettingsSheet: View {
    @Binding var showProfileSheet: Bool
    
    var body: some View {
        
        
        
        Button("Press to dismiss") {
            showProfileSheet = false
        }
        .font(.title)
        .padding()
        .background(Color.black)
    }
}

//struct SettingsSheet_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingsSheet()
//    }
//}
