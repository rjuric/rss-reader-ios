//
//  FeedListViewModelTests.swift
//  RSS ReaderTests
//
//  Created by rjuric on 30.04.2024..
//

import XCTest
import Combine
@testable import RSS_Reader

@MainActor
final class FeedListViewModelTests: XCTestCase {
    var sut: FeedListViewModel!
    var repository: ChannelRepositoryMock!
    var appFlagsService: AppFlagsPersistenceServiceStub!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        repository = ChannelRepositoryMock()
        appFlagsService = AppFlagsPersistenceServiceStub()
        
        sut = FeedListViewModel(
            getChannelsAndNewArticleCountPublisher: GetChannelAndNewArticleCountPublisherUseCase(
                getChannelsPublisher: GetChannelsPublisherUseCase(channelRepository: repository),
                getNewArticleCountPublisher: GetNewArticleCountPublisherUseCase(channelRepository: repository),
                mergeChannelsWithNewArticleCounts: MergeChannelsAndNewArticlesCountUseCase()
            ),
            initializeWithStoredChannels: InitializeWithStoredChannelsUseCase(channelRepository: repository),
            deleteChannel: UnsubscribeFromChannelUseCase(channelRepository: repository),
            updateChannel: UpdateChannelUseCase(channelRepository: repository),
            getDidShowOnboarding: GetDidShowOnboardingUseCase(getAppFlags: GetAppFlagsUseCase(persistenceService: appFlagsService)),
            refreshAllChannels: RefreshAllChannelsUseCase(channelRepository: repository)
        )
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
        appFlagsService = nil
        repository = nil
    }
    
    func test_showsOnboarding_on_noAppFlags() async throws {
        await sut.onAppearTask()
        
        XCTAssertTrue(sut.isPresentingNewFeed)
    }
    
    func test_showsOnboarding_on_onboardingNotShown() async throws {
        appFlagsService.fetchResult = AppFlags(didShowOnboarding: false)
        
        await sut.onAppearTask()
        
        XCTAssertTrue(sut.isPresentingNewFeed)
    }
    
    func test_doesntShowOnboarding_on_onboardingAlreadyShown() async throws {
        appFlagsService.fetchResult = AppFlags(didShowOnboarding: true)
        
        await sut.onAppearTask()
        
        XCTAssertFalse(sut.isPresentingNewFeed)
    }
    
    func test_doesntShowNewFeedCell_before_initialisationComplete() throws {
        XCTAssertFalse(sut.isShowingNewFeedCell)
    }
    
    func test_showsNewFeedCell_after_initialisationComplete() async throws {
        repository.channelSubject.send([Channel(title: "Title 1", description: "Description 1", url: URL(string: "https://example.com")!)])
        
        await sut.onAppearTask()
        try? await Task.sleep(for: .milliseconds(20))
        
        XCTAssertTrue(sut.isShowingNewFeedCell)
    }

    func test_toggleFavorites_toggles_isFiltering() throws {
        XCTAssertFalse(sut.isFilteringFavorites)
        sut.onStarButtonTapped()
        XCTAssertTrue(sut.isFilteringFavorites)
        sut.onStarButtonTapped()
        XCTAssertFalse(sut.isFilteringFavorites)
    }
    
    func test_filteringDoesntChangeOutput_if_isFilteringFalse() async throws {
        let channels = [Channel(title: "Title 1", description: "Description 1", url: URL(string: "https://example.com")!)]
        repository.channelSubject.send(channels)
        
        await sut.onAppearTask()
        try? await Task.sleep(for: .milliseconds(20))
        sut.isFilteringFavorites = false
        
        XCTAssertEqual(channels, sut.filteredChannels.map(\.channel))
    }
    
    func test_filteringChangesOutput_if_isFilteringTrue() async throws {
        let channels = [Channel(title: "Title 1", description: "Description 1", url: URL(string: "https://example.com")!)]
        repository.channelSubject.send(channels)
        
        await sut.onAppearTask()
        try? await Task.sleep(for: .milliseconds(20))
        sut.isFilteringFavorites = true
        
        XCTAssertNotEqual(channels, sut.filteredChannels.map(\.channel))
    }
    
    func test_showsOnlyFavorites_if_isFilteringTrue() async throws {
        let channels = [
            Channel(title: "Title 1", description: "Description 1", url: URL(string: "https://example.com")!),
            Channel(title: "Title 2", description: "Description 2", isFavorite: true, url: URL(string: "https://example2.com")!)
        ]
        repository.channelSubject.send(channels)
        
        await sut.onAppearTask()
        try? await Task.sleep(for: .milliseconds(20))
        sut.isFilteringFavorites = true
        
        XCTAssertNotEqual(channels, sut.filteredChannels.map(\.channel))
        XCTAssertTrue(sut.filteredChannels.map(\.channel).contains(channels[1]))
        XCTAssertEqual(sut.filteredChannels.map(\.channel).count, 1)
    }
    
    func test_onDeleteChannel_calls_repositoryMethod() throws {
        let channel = Channel(title: "Title 1", description: "Description 1", url: URL(string: "https://example.com")!)
        
        sut.onDelete(channel)
        
        XCTAssertTrue(repository.removeCalled)
        XCTAssertEqual(repository.removeCalledFor.count, 1)
        XCTAssertEqual(channel, repository.removeCalledFor.first)
    }
    
    func test_onFavorite_calls_repositoryMethod() throws {
        let channel = Channel(title: "Title 1", description: "Description 1", url: URL(string: "https://example.com")!)
        
        sut.onFavorite(channel)
        
        XCTAssertTrue(repository.updateCalled)
        XCTAssertEqual(Channel(title: "Title 1", description: "Description 1", isFavorite: true, url: URL(string: "https://example.com")!), repository.updateCalledWith.first)
        XCTAssertEqual(repository.updateCalledWith.count, 1)
    }
    
    func test_onPlusTapped_opens_newFeed() throws {
        XCTAssertFalse(sut.isPresentingNewFeed)
        
        sut.onPlusTapped()
        
        XCTAssertTrue(sut.isPresentingNewFeed)
    }
    
    func test_onAppear_calls_repository() async throws {
        XCTAssertEqual(repository.loadFromLocalStorageCallsCount, 0)
        
        await sut.onAppearTask()
        
        XCTAssertEqual(repository.loadFromLocalStorageCallsCount, 1)
    }
    
    func test_onAppearSkipped_on_subsequentCalls() async throws {
        await sut.onAppearTask()
        try? await Task.sleep(for: .milliseconds(20))
        await sut.onAppearTask()
        
        XCTAssertEqual(repository.loadFromLocalStorageCallsCount, 1)
    }
    
    func test_showsError_on_onAppearError() async throws {
        repository.loadFromLocalStorageResult = .failure(RssReaderError.wrongFeedFormat)
        
        await sut.onAppearTask()
        
        XCTAssertEqual(repository.loadFromLocalStorageCallsCount, 1)
        XCTAssertTrue(sut.isError)
    }
    
    func test_refresh_calls_repositoryMethod() async throws {
        await sut.onRefreshAction()
        
        XCTAssertEqual(repository.refreshAllChannelsCallsCount, 1)
    }
    
    func test_showsError_on_refreshFailure() async throws {
        repository.refreshAllChannelsResult = .failure(RssReaderError.wrongFeedFormat)
        
        await sut.onRefreshAction()
        
        XCTAssertEqual(repository.refreshAllChannelsCallsCount, 1)
        XCTAssertTrue(sut.isError)
    }
}
