//
//  FeedNavigationWrapper.swift
//  RSS Reader
//
//  Created by rjuric on 24.04.2024..
//

import SwiftUI

struct FeedNavigationWrapper<Content: View>: View {
    @ObservedObject var viewModel: FeedNavigationViewModel
    @ViewBuilder var content: Content
    
    var body: some View {
        NavigationStack(path: $viewModel.path) {
            content
                .navigationDestination(for: NavigationDestination.self) { item in
                    switch item {
                    case let .feedArticles(viewModel):
                        ArticlesListView(viewModel: viewModel)
                    case let .article(viewModel):
                        ArticleView(viewModel: viewModel)
                    }
                }
        }
    }
}

#Preview {
    FeedNavigationWrapper(
        viewModel: FeedNavigationViewModel(
            feedListViewModel: FeedListViewModel()
        )
    ) {
        Text("Placeholder")
    }
}
