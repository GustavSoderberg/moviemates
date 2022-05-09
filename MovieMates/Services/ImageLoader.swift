//
//  ImageLoader.swift
//  MovieMates
//
//  Created by Denis Rakitin on 2022-05-09.
//

//import Combine
//import SwiftUI
//
//class ImageLoader: ObservableObject {
//    @Published var image: UIImage = UIImage()
//    
//    func loadImage(for urlString: String) {
//        guard let url = URL(string: urlString) else { return }
//        
//        let task = URLSession.shared.dataTask(with: url) { data, response, error in
//            guard let data = data else { return }
//            DispatchQueue.main.async {
//                self.image = UIImage(data: data) ?? UIImage()
//            }
//        }
//        task.resume()
//    }
//}
