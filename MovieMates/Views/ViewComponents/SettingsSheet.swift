//
//  SettingsSheet.swift
//  MovieMates
//
//  Created by Sarah Lidberg on 2022-05-09.
//

import SwiftUI

struct SettingsSheet: View {
    @Binding var showProfileSheet: Bool
    @Binding var changeUsername: String
    @State private var changeTheme = 0
    @State private var changeRegion = 0
    
    var body: some View {
        
        Text("Username: ")
        TextField("Change username: ", text: $changeUsername)
        
        Text("Theme: ")
        Picker("Theme", selection: $changeTheme){
            Text("Theme 1").tag(0)
            Text("Theme 2").tag(1)
            Text("Theme 3").tag(2)
        }.pickerStyle(SegmentedPickerStyle())
            .colorMultiply(.red)
        
        Text("Region: ")
        Picker("Region", selection: $changeRegion){
            Text("Sweden").tag(0)
                .background(.green)
            Text("USA").tag(1)
                .background(.blue)
            Text("China").tag(2)
                .background(.pink)
        }.pickerStyle(SegmentedPickerStyle())
            .colorMultiply(.red)
        
        Button("Press to dismiss") {
            showProfileSheet = false
        }
        .font(.title2)
        .padding()
        .cornerRadius(25)
        .background(Color("inputs"))
        .foregroundColor(.red)
    }
}

//struct SettingsSheet_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingsSheet()
//    }
//}
