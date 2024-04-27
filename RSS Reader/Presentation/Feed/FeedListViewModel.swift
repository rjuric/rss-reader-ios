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
    private let updateChannel: UpdateChanelUseCaseProtocol
    private let getDidShowOnboarding: GetDidShowOnboardingUseCaseProtocol
    
    init(
        getChannelsPublisher: GetChannelsPublisherUseCaseProtocol = GetChannelsPublisherUseCase(),
        initializeWithStoredChannels: InitializeWithStoredChannelsUseCaseProtocol = InitializeWithStoredChannelsUseCase(),
        deleteChannel: UnsubscribeFromChannelUseCaseProtocol = UnsubscribeFromChannelUseCase(),
        updateChannel: UpdateChanelUseCaseProtocol = UpdateChanelUseCase(),
        getDidShowOnboarding: GetDidShowOnboardingUseCaseProtocol = GetDidShowOnboardingUseCase()
    ) {
        self.getChannelsPublisher = getChannelsPublisher
        self.initializeWithStoredChannels = initializeWithStoredChannels
        self.deleteChannel = deleteChannel
        self.updateChannel = updateChannel
        self.getDidShowOnboarding = getDidShowOnboarding
    }
    
    deinit {
        channelPublisher?.cancel()
    }
    
    private var channelPublisher: AnyCancellable?
    
    @Published private var rssFeeds: [Channel]?
    @Published var isLoading = false
    
    @Published var isFilteringFavorites = false

    @Published var isPresentingNewFeed = false
    
    var filteredFeeds: [Channel] {
        guard let rssFeeds else { return [] }
        
        return isFilteringFavorites ? rssFeeds.filter({ $0.isFavorite }) : rssFeeds
    }
    
    func articlesViewModel(for feed: Channel) -> ArticlesListViewModel {
        ArticlesListViewModel(
            articles: feed.articles,
            publication: feed.title
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
        feed.isFavorite ? "Remove from favorites" : "Favorite"
    }
    
    func toggleFavoriteIcon(for feed: Channel) -> String {
        feed.isFavorite ? Constants.SymbolNames.star : Constants.SymbolNames.starFilled
    }
    
    var deleteActionLabel: String {
        "Remove from list"
    }
    
    var deleteActionIcon: String {
        Constants.SymbolNames.trash
    }
    
    func onPlusTapped() {
        isPresentingNewFeed = true
    }
    
    private func fetchAndSetRssFeeds() async {
        try? await Task.sleep(for: .seconds(2))
        
        // TODO: Item fetching and persistence
        
//        withAnimation {
//            rssFeeds = [
//                Channel(
//                    title: "Slobodna Dalmacija",
//                    image: URL(string: "https://picsum.photos/200"),
//                    description: "Svježe iz Dalmacije",
//                    isFavorite: true,
//                    articles: [
//                        Article(
//                            title: "[ŠOK] Prebio dvojicu ispred Velveta",
//                            image: URL(string: "https://picsum.photos/200")!,
//                            description: "Pogledajte što je napravio"
//                        ),
//                        Article(
//                            title: "[VIDEO] Raspudići napuštaju Most",
//                            image: nil,
//                            description: "Tragedija hrvatskog naroda"
//                        ),
//                        Article(
//                            title: "Penava: Što rade našoj djeci?",
//                            image: URL(string: "https://picsum.photos/200")!,
//                            description: "Djeca uče arapske brojeve u školi"
//                        ),
//                    ]
//                ),
//                Channel(
//                    title: "Jutarnji List",
//                    description: "RSS Feed Jutarnjeg"
//                ),
//                Channel(
//                    title: "Vecernji",
//                    description: "RSS Feed Vecernjeg Lista s najnovijim vijestima",
//                    articles: [
//                        Article(
//                            title: "[VIDEO] Raspudići napuštaju Most",
//                            image: nil,
//                            description: "Tragedija hrvatskog naroda"
//                        ),
//                        Article(
//                            title: "Penava: Što rade našoj djeci?",
//                            image: URL(string: "https://picsum.photos/200")!,
//                            description: "Djeca uče arapske brojeve u školi"
//                        ),
//                    ]
//                )
//            ]
//        }
    }
    
    func onAppearTask() async {
//        guard rssFeeds.isNil else { return }
//        
//        isLoading = true
//        defer { isLoading = false }
//        
//        await fetchAndSetRssFeeds()
        
        initializeWithStoredChannels()
        
        channelPublisher = getChannelsPublisher()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] channels in
                self?.rssFeeds = channels
            }
        
        isPresentingNewFeed = !getDidShowOnboarding()
        // TODO: Finish this
    }
    
    func onRefreshAction() async {
        await fetchAndSetRssFeeds()
    }
}
