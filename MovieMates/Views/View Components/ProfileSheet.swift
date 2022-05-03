//
//  ProfileSheet.swift
//  MovieMates
//
//  Created by Sarah Lidberg on 2022-05-03.
//

import SwiftUI

struct ProfileSheet: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Button("Press to dismiss") {
                    dismiss()
                }
                .font(.title)
                .padding()
                .background(Color.black)
        
        
        
    }
}




struct ProfileSheet_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSheet()
    }
}
