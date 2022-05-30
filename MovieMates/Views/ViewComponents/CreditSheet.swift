//
//  CreditSheet.swift
//  MovieMates
//
//  Created by Karol Oman on 2022-05-30.
//

import SwiftUI

struct CreditSheet: View {
    @AppStorage("darkmode") private var darkmode = true
    
    @Binding var showCreditSheet: Bool
    
    var body: some View {
        VStack {
            
            HStack {
                
                Button {
                    showCreditSheet = false
                } label: {
                    Text("Back")
                }.padding()
                
                Spacer()
                
            }
            
            Spacer()
            
            Text("CREDITS")
            
            
        }
        
    }
}


//struct CreditSheet_Previews: PreviewProvider {
//    static var previews: some View {
//        CreditSheet()
//    }
//}
