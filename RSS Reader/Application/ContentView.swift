//
//  ContentView.swift
//  RSS Reader
//
//  Created by rjuric on 24.04.2024..
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        let feedListViewModel = FeedListViewModel()
        let viewModel = FeedNavigationViewModel(feedListViewModel: feedListViewModel)
        
        FeedNavigationWrapper(viewModel: viewModel) {
            FeedListView(viewModel: feedListViewModel)
        }
    }
}

#Preview {
    ContentView()
}
