//
//  FeedNavigationViewModel.swift
//  RSS Reader
//
//  Created by rjuric on 24.04.2024..
//

import SwiftUI

@MainActor
final class FeedNavigationViewModel: ObservableObject {
    @Published var path = NavigationPath()
    
    let feedListViewModel: FeedListViewModel
    
    init(path: NavigationPath = NavigationPath(), feedListViewModel: FeedListViewModel) {
        self.path = path
        self.feedListViewModel = feedListViewModel
    }
}
