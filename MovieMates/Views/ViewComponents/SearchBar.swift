/**
 
 - Description:
    The view of the search bar with it's corresponding functions
 
 - Authors:
    Karol Ö
    Oscar K
    Sarah L
    Joakim A
    Denis R
    Gustav S
 
 
 */

import Foundation
import SwiftUI

struct SearchBar: UIViewRepresentable {

    @Binding var text: String
    var onSearchButtonClicked: (() -> Void)? = nil
    var onCancelButtonClicked: (() -> Void)? = nil

    class Coordinator: NSObject, UISearchBarDelegate {

        //create a search bar instance
        let control: SearchBar

        init(_ control: SearchBar) {
            self.control = control
        }

        //control if text in search bar changed and update search term. If search text is empty, cancel search function is called
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            control.text = searchText
            if searchText == "" {
                control.onCancelButtonClicked?()
            }
        }

        //function call api request when search button clicked and hide keyboard
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            control.onSearchButtonClicked?()
            searchBar.resignFirstResponder()
        }

    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    //recreate SearchBar view
    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        return searchBar
    }
    
    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
        uiView.text = text
    }

}
 
