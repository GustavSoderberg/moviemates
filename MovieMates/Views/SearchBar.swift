//
//  SearchBar.swift
//  MovieMates
//
//  Created by Denis Rakitin on 2022-05-08.
//

import Foundation
import SwiftUI

struct SearchBar: UIViewRepresentable {

    @Binding var text: String
    var onSearchButtonClicked: (() -> Void)? = nil
    var onCancelButtonClicked: (() -> Void)? = nil

    class Coordinator: NSObject, UISearchBarDelegate {

        let control: SearchBar

        init(_ control: SearchBar) {
            self.control = control
        }

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            control.text = searchText
            if searchText == "" {
                control.onCancelButtonClicked?()
            }
        }

        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            control.onSearchButtonClicked?()
        }

    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        return searchBar
    }
    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
        uiView.text = text
    }

}
 
