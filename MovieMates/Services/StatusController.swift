//
//  StatusController.swift
//  MovieMates
//
//  Created by Joakim Andersson on 2022-05-24.
//
/**
 - Description:
 
 */

import Foundation

class StatusController: ObservableObject {
    @Published var viewShowing: Status = .Loading
    @Published var selection = 2
    @Published var searchIndex = "movies"
}

enum Status {
    case Loading, WelcomeView, HomeView
}
