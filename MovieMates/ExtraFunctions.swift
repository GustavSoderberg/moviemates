//
//  ExtraFunctions.swift
//  MovieMates
//
//  Created by Oscar Karlsson on 2022-05-23.
//

import SwiftUI

struct gap :View {
    var height: CGFloat?
    var body: some View {
        Rectangle()
            .frame(height: height)
            .foregroundColor(.clear)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {
    
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
