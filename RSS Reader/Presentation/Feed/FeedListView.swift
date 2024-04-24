//
//  FeedListView.swift
//  RSS Reader
//
//  Created by rjuric on 24.04.2024..
//

import SwiftUI

struct FeedListView: View {
    @StateObject private var viewModel = FeedListViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.filteredFeeds) { rssFeed in
                NavigationLink(value: NavigationDestination.rssFeed) {
                    FeedRowView(feed: rssFeed)
                }
                .contextMenu {
                    Button(
                        action: { viewModel.onFavorite(rssFeed) },
                        label: {
                            let favoriteTitle = viewModel.toggleFavoriteLabel(for: rssFeed)
                            let favoriteIcon = viewModel.toggleFavoriteIcon(for: rssFeed)
                            
                            Label(favoriteTitle, systemImage: favoriteIcon)
                        }
                    )
                    Button(
                        role: .destructive,
                        action: { viewModel.onDelete(rssFeed) },
                        label: {
                            Label(viewModel.deleteActionLabel, systemImage: viewModel.deleteActionIcon)
                        }
                    )
                }
            }
            
            if viewModel.isShowingNewFeedCell {
                NewFeedRowView()
                    .onTapGesture {
                        viewModel.onPlusTapped()
                    }
            }
        }
        .listStyle(.plain)
        .navigationTitle("RSS Feeds")
        .sheet(isPresented: $viewModel.isPresentingNewFeed) {
            let isFirstFeed = viewModel.isFirstFeed
            
            NewFeedView(viewModel: NewFeedViewModel(isFirstFeed: isFirstFeed))
                .interactiveDismissDisabled(isFirstFeed)
                .presentationBackground(Material.ultraThin)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: viewModel.onPlusTapped) {
                    Image(systemName: "plus")
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: viewModel.onStarButtonTapped) {
                    if viewModel.isFilteringFavorites {
                        Image(systemName: "star.fill")
                    } else {
                        Image(systemName: "star")
                    }
                }
            }
        }
        .task { await viewModel.onAppearTask() }
        .refreshable { await viewModel.onRefreshAction() }
        .isLoading(viewModel.isLoading)
    }
}

#Preview {
    FeedNavigationWrapper {
        FeedListView()
    }
}
