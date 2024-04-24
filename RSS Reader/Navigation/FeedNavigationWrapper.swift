//
//  FeedNavigationWrapper.swift
//  RSS Reader
//
//  Created by rjuric on 24.04.2024..
//

import SwiftUI

struct FeedNavigationWrapper<Content: View>: View {
    @ViewBuilder var content: Content
    
    @StateObject var viewModel = FeedNavigationViewModel()
    
    var body: some View {
        NavigationStack(path: $viewModel.path) {
            content
                .navigationDestination(for: NavigationDestination.self) { item in
                    switch item {
                    case .rssFeed:
                        Text("TODO: RSS Item List View")
                    case .feedItem:
                        Text("TODO: RSS Article Item")
                    }
                }
        }
    }
}

#Preview {
    FeedNavigationWrapper {
        Text("Some text here")
    }
}
