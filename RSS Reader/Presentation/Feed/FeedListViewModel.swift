//
//  FeedListViewModel.swift
//  RSS Reader
//
//  Created by rjuric on 24.04.2024..
//

import SwiftUI
import Combine

@MainActor
final class FeedListViewModel: ObservableObject {
    private let getChannelsPublisher: GetChannelsPublisherUseCaseProtocol
    private let initializeWithStoredChannels: InitializeWithStoredChannelsUseCaseProtocol
    private let deleteChannel: UnsubscribeFromChannelUseCaseProtocol
    private let updateChannel: UpdateChannelUseCaseProtocol
    private let getDidShowOnboarding: GetDidShowOnboardingUseCaseProtocol
    private let getNewArticlesCount: GetNewArticlesCountUseCaseProtocol
    
    init(
        getChannelsPublisher: GetChannelsPublisherUseCaseProtocol = GetChannelsPublisherUseCase(),
        initializeWithStoredChannels: InitializeWithStoredChannelsUseCaseProtocol = InitializeWithStoredChannelsUseCase(),
        deleteChannel: UnsubscribeFromChannelUseCaseProtocol = UnsubscribeFromChannelUseCase(),
        updateChannel: UpdateChannelUseCaseProtocol = UpdateChannelUseCase(),
        getDidShowOnboarding: GetDidShowOnboardingUseCaseProtocol = GetDidShowOnboardingUseCase(),
        getNewArticlesCount: GetNewArticlesCountUseCaseProtocol = GetNewArticlesCount()
    ) {
        self.getChannelsPublisher = getChannelsPublisher
        self.initializeWithStoredChannels = initializeWithStoredChannels
        self.deleteChannel = deleteChannel
        self.updateChannel = updateChannel
        self.getDidShowOnboarding = getDidShowOnboarding
        self.getNewArticlesCount = getNewArticlesCount
    }
    
    deinit {
        channelPublisher?.cancel()
    }
    
    private var channelPublisher: AnyCancellable?
    
    @Published private var rssFeeds: [Channel]?
    @Published var isFilteringFavorites = false
    @Published var isPresentingNewFeed = false
    @Published var isError = false
    
    var filteredFeeds: [Channel] {
        guard let rssFeeds else { return [] }
        
        return isFilteringFavorites ? rssFeeds.filter({ $0.isFavorite }) : rssFeeds
    }
    
    func articlesViewModel(for feed: Channel) -> ArticlesListViewModel {
        ArticlesListViewModel(
            articles: feed.articles,
            publication: feed.title,
            id: feed.id
        )
    }
    
    var isShowingNewFeedCell: Bool {
        !rssFeeds.isNil
    }
    
    func onStarButtonTapped() {
        withAnimation(.default) {
            isFilteringFavorites.toggle()
        }
    }
    
    func onDelete(_ channel: Channel) {
        deleteChannel(channel)
    }
    
    func onFavorite(_ channel: Channel) {
        let updated = Channel(
            title: channel.title,
            image: channel.image,
            description: channel.description,
            isFavorite: !channel.isFavorite,
            articles: channel.articles,
            url: channel.url
        )
        
        updateChannel(updated)
    }
    
    func toggleFavoriteLabel(for feed: Channel) -> String {
        let removeFromFavorites = String(localized: "RowView.ContextMenu.Favorites.Remove")
        let addToFavorites = String(localized: "RowView.ContextMenu.Favorites.Add")
        return feed.isFavorite ? removeFromFavorites : addToFavorites
    }
    
    func toggleFavoriteIcon(for feed: Channel) -> String {
        feed.isFavorite ? Constants.SymbolNames.star : Constants.SymbolNames.starFilled
    }
    
    var deleteActionLabel: String {
        String(localized: "RowView.ContextMenu.Delete")
    }
    
    var deleteActionIcon: String {
        Constants.SymbolNames.trash
    }
    
    func onPlusTapped() {
        isPresentingNewFeed = true
    }
    
    func newArticlesCount(for feed: Channel) -> Int {
        getNewArticlesCount(for: feed.id)
    }
    
    func onAppearTask() async {
        do {
            try await initializeWithStoredChannels()
        } catch {
            isError = true
        }
        
        channelPublisher = getChannelsPublisher()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] channels in
                self?.rssFeeds = channels
            }
        
        isPresentingNewFeed = !getDidShowOnboarding()
    }
    
    func onRefreshAction() async {
        
    }
}
