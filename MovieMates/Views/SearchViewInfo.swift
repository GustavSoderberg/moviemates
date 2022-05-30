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
