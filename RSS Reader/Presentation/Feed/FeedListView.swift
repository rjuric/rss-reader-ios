//
//  FeedListView.swift
//  RSS Reader
//
//  Created by rjuric on 24.04.2024..
//

import SwiftUI

struct FeedListView: View {
    @ObservedObject var viewModel: FeedListViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(viewModel.filteredChannels) { articleCountChannel in
                    let destination = NavigationDestination.feedArticles(
                        viewModel.articlesViewModel(for: articleCountChannel.channel)
                    )
                    
                    NavigationLink(value: destination) {
                        RowView(
                            viewModel: RowViewModel(
                                from: articleCountChannel.channel,
                                with: articleCountChannel.articleCount
                            )
                        )
                    }
                    .contextMenu {
                        Button(
                            action: { viewModel.onFavorite(articleCountChannel.channel) },
                            label: {
                                let favoriteTitle = viewModel.toggleFavoriteLabel(for: articleCountChannel.channel)
                                let favoriteIcon = viewModel.toggleFavoriteIcon(for: articleCountChannel.channel)
                                
                                Label(favoriteTitle, systemImage: favoriteIcon)
                            }
                        )
                        Button(
                            role: .destructive,
                            action: { viewModel.onDelete(articleCountChannel.channel) },
                            label: {
                                Label(viewModel.deleteActionLabel, systemImage: viewModel.deleteActionIcon)
                            }
                        )
                    }
                    .transition(.move(edge: .trailing).combined(with: .opacity))
                    
                    Divider()
                        .overlay(Color.primary)
                        .padding(.horizontal, 16)
                        .transition(.move(edge: .trailing).combined(with: .opacity))
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
            .animation(.bouncy, value: viewModel.isFilteringFavorites)
        }
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
    struct Content: View {
        @StateObject private var viewModel = FeedNavigationViewModel(
            feedListViewModel: FeedListViewModel(
                getChannelsAndNewArticleCountPublisher: PreviewGetChannelAndNewArticleCountPublisherUseCase(),
                initializeWithStoredChannels: PreviewInitializeWithStoredChannelsUseCase(),
                deleteChannel: PreviewUnsubscribeFromChannelUseCase(),
                updateChannel: PreviewUpdateChannelUseCase(),
                getDidShowOnboarding: PreviewGetDidShowOnboardingUseCase(returnValue: false),
                refreshAllChannels: PreviewRefreshAllChannelsUseCase(isErroring: false)
            )
        )
        
        var body: some View {
            FeedNavigationWrapper(viewModel: viewModel) {
                FeedListView(viewModel: viewModel.feedListViewModel)
            }
        }
    }
    
    return Content()
}
