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
            
            Image("moviemates")
                .resizable()
                .frame(width: 150, height: 150)
                .padding()
            
            VStack(alignment: .center) {
                Text("Developers:")
                    .font(.title)
                    .padding(.bottom)
                
                VStack(alignment: .leading) {
                    
                    Text("Denis Rakitin")
                    Text("Gustav Söderberg")
                    Text("Joakim Andersson")
                    Text("Karol Öman")
                    Text("Oscar Karlsson")
                    Text("Sarah Lidberg")
                    
                }
            }.padding(.bottom)
            
            Image("tmdb")
                .resizable()
                .frame(width: 75, height: 75)
                .padding()
            
            Text("This product uses the TMDB API but is not endorsed or certified by TMDB.")
                .padding()
            
            Spacer()
            
            
        }
        
    }
}


//struct CreditSheet_Previews: PreviewProvider {
//    static var previews: some View {
//        CreditSheet()
//    }
//}
