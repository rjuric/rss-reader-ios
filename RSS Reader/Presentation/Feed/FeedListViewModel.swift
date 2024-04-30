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
    private let getChannelsAndNewArticleCountPublisher: GetChannelAndNewArticleCountPublisherUseCaseProtocol
    private let initializeWithStoredChannels: InitializeWithStoredChannelsUseCaseProtocol
    private let deleteChannel: UnsubscribeFromChannelUseCaseProtocol
    private let updateChannel: UpdateChannelUseCaseProtocol
    private let getDidShowOnboarding: GetDidShowOnboardingUseCaseProtocol
    private let refreshAllChannels: RefreshAllChannelsUseCaseProtocol
    
    init(
        getChannelsAndNewArticleCountPublisher: GetChannelAndNewArticleCountPublisherUseCaseProtocol = GetChannelAndNewArticleCountPublisherUseCase(),
        initializeWithStoredChannels: InitializeWithStoredChannelsUseCaseProtocol = InitializeWithStoredChannelsUseCase(),
        deleteChannel: UnsubscribeFromChannelUseCaseProtocol = UnsubscribeFromChannelUseCase(),
        updateChannel: UpdateChannelUseCaseProtocol = UpdateChannelUseCase(),
        getDidShowOnboarding: GetDidShowOnboardingUseCaseProtocol = GetDidShowOnboardingUseCase(),
        refreshAllChannels: RefreshAllChannelsUseCaseProtocol = RefreshAllChannelsUseCase()
    ) {
        self.getChannelsAndNewArticleCountPublisher = getChannelsAndNewArticleCountPublisher
        self.initializeWithStoredChannels = initializeWithStoredChannels
        self.deleteChannel = deleteChannel
        self.updateChannel = updateChannel
        self.getDidShowOnboarding = getDidShowOnboarding
        self.refreshAllChannels = refreshAllChannels
    }
    
    deinit {
        articleCountChannelPublisher?.cancel()
    }
    
    private var articleCountChannelPublisher: AnyCancellable?
    
    @Published private var channels: [ArticleCountChannel]?
    @Published var isFilteringFavorites = false
    @Published var isPresentingNewFeed = false
    @Published var isError = false
    
    var filteredChannels: [ArticleCountChannel] {
        guard let channels else { return [] }
        
        return isFilteringFavorites ? channels.filter({ $0.channel.isFavorite }) : channels
    }
    
    func articlesViewModel(for channel: Channel) -> ArticlesListViewModel {
        ArticlesListViewModel(
            articles: channel.articles,
            publication: channel.title,
            id: channel.id
        )
    }
    
    var isShowingNewFeedCell: Bool {
        !channels.isNil
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
    
    func onAppearTask() async {
        guard channels.isNil else { return }
        
        do {
            try await initializeWithStoredChannels()
        } catch {
            isError = true
        }
        
        articleCountChannelPublisher = getChannelsAndNewArticleCountPublisher()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] channels in
                self?.channels = channels
            }
        
        isPresentingNewFeed = !getDidShowOnboarding()
    }
    
    func onRefreshAction() async {
        do {
            try await refreshAllChannels()
        } catch {
            isError = true
        }
    }
}
