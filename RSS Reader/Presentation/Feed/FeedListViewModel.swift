//
//  FeedListViewModel.swift
//  RSS Reader
//
//  Created by rjuric on 24.04.2024..
//

import SwiftUI

@MainActor
final class FeedListViewModel: ObservableObject {
    @Published private var rssFeeds: [RssFeed] = []
    @Published var isLoading = false
    
    @Published var isFilteringFavorites = false
    
    var filteredFeeds: [RssFeed] {
        isFilteringFavorites ? rssFeeds.filter({ $0.isFavorite }) : rssFeeds
    }
    
    func onStarButtonTapped() {
        withAnimation(.default) {
            isFilteringFavorites.toggle()
        }
    }
    
    func onDelete(_ feed: RssFeed) {
        rssFeeds.removeAll(where: { $0.id == feed.id })
        
        // TODO: Persistance
    }
    
    func onFavorite(_ feed: RssFeed) {
        guard let feedIndex = rssFeeds.firstIndex(where: { $0.id == feed.id }) else {
            return
        }
        
        rssFeeds[feedIndex].isFavorite.toggle()
        
        // TODO: Persistance
    }
    
    func toggleFavoriteLabel(for feed: RssFeed) -> String {
        feed.isFavorite ? "Remove from favorites" : "Favorite"
    }
    
    func toggleFavoriteIcon(for feed: RssFeed) -> String {
        feed.isFavorite ? "star" : "star.fill"
    }
    
    var deleteActionLabel: String {
        "Remove from list"
    }
    
    var deleteActionIcon: String {
        "trash"
    }
    
    func onAppearTask() async {
        isLoading = true
        defer { isLoading = false }
        
        try? await Task.sleep(for: .seconds(1))
        
        // TODO: Item fetching and persistence
        
        withAnimation {
            rssFeeds = [
                RssFeed(
                    title: "Slobodna Dalmacija",
                    image: URL(string: "https://picsum.photos/200"),
                    description: "Svježe iz Dalmacije",
                    isFavorite: true
                ),
                RssFeed(
                    title: "Jutarnji List",
                    description: "RSS Feed Jutarnjeg"
                ),
                RssFeed(
                    title: "Vecernji",
                    description: "RSS Feed Vecernjeg Lista s najnovijim vijestima"
                )
            ]
        }
    }
}
