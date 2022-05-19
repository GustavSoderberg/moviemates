//
//  SearchViewInfo.swift
//  MovieMates
//
//  Created by Denis Rakitin on 2022-05-10.
//

import SwiftUI

struct SearchViewInfo: View {
    
    @Binding var infoText: String
    
    var body: some View {
        Text(infoText)
    }
}

//struct SearchViewInfo_Previews: PreviewProvider {
//    
//    @Binding infoText: String = "Type to search"
//    static var previews: some View {
//        SearchViewInfo(infoText: infoText)
//    }
//}
 
