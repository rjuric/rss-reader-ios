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
                let destination = NavigationDestination.feedArticles(
                    viewModel.articlesViewModel(for: rssFeed)
                )
                
                let newArticlesCount = viewModel.newArticlesCount(for: rssFeed)
                
                NavigationLink(value: destination) {
                    RowView(viewModel: RowViewModel(from: rssFeed, with: newArticlesCount))
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
                RowView(
                    viewModel: RowViewModel(
                        title: String(localized: "RowView.Empty.Title"),
                        image: .symbol(Constants.SymbolNames.plusInsideCircle),
                        description: String(localized: "RowView.Empty.Description")
                    )
                )
                .onTapGesture {
                    viewModel.onPlusTapped()
                }
            }
        }
        .listStyle(.plain)
        .navigationTitle("FeedListView.Navigation.Title")
        .sheet(isPresented: $viewModel.isPresentingNewFeed) {
            NewFeedView(viewModel: NewFeedViewModel())
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: viewModel.onPlusTapped) {
                    Image(systemName: Constants.SymbolNames.plus)
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: viewModel.onStarButtonTapped) {
                    if viewModel.isFilteringFavorites {
                        Image(systemName: Constants.SymbolNames.starFilled)
                    } else {
                        Image(systemName: Constants.SymbolNames.star)
                    }
                }
            }
        }
        .task { await viewModel.onAppearTask() }
        .refreshable { await viewModel.onRefreshAction() }
        .alert(
            "Common.Error.Title",
            isPresented: $viewModel.isError,
            actions: {
                Button("Common.Retry") {
                    Task { await viewModel.onAppearTask() }
                }
                Button("Common.Cancel", action: {})
            },
            message: {
                Text("Common.Error.Description")
            }
        )
    }
}

#Preview {
    FeedNavigationWrapper {
        FeedListView()
    }
}
