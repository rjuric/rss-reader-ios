//
//  ChannelRepositoryTests.swift
//  RSS ReaderTests
//
//  Created by rjuric on 30.04.2024..
//

import XCTest
@testable import RSS_Reader

final class ChannelRepositoryTests: XCTestCase {
    var sut: ChannelRepository!
    var remoteDatasource: RemoteChannelDatasourceStub!
    var localDatasource: LocalChannelDatasourceStub!
    var refreshManager: RefreshManagerMock!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        remoteDatasource = RemoteChannelDatasourceStub()
        localDatasource = LocalChannelDatasourceStub()
        refreshManager = RefreshManagerMock()
        sut = ChannelRepository(
            remoteDatasource: remoteDatasource,
            localDatasource: localDatasource,
            refreshManager: refreshManager,
            checkDifferentArticlesCount: CheckDifferentArticlesCountUseCase()
        )
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        sut = nil
        remoteDatasource = nil
        localDatasource = nil
        refreshManager = nil
    }

    func test_loadFromLocalStorage_calls_localDatasource() async throws {
        let channels = [
            Channel(title: "Title 1", description: "Desc 1", url: URL(string: "https://example.com")!),
            Channel(title: "Title 2", description: "Desc 2", url: URL(string: "https://example2.com")!)
        ]
        
        localDatasource.getResult = channels
        
        try await sut.loadFromLocalStorage()
        
        XCTAssertEqual(localDatasource.getWasCalledTimes, 1)
    }
    
    func test_loadFromLocalStorage_doesntCallRemoteDatasource_when_localDatasourceIsEmpty() async throws {
        localDatasource.getResult = []
        
        try await sut.loadFromLocalStorage()
        
        XCTAssertEqual(localDatasource.getWasCalledTimes, 1)
        XCTAssertTrue(remoteDatasource.wasCalledWith.isEmpty)
    }
    
    func test_loadFromLocalStorage_callsRemoteDatasource_when_localDatasourceHasValues() async throws {
        let channels = [
            Channel(title: "Title 1", description: "Desc 1", url: URL(string: "https://example.com")!),
            Channel(title: "Title 2", description: "Desc 2", url: URL(string: "https://example2.com")!)
        ]
        localDatasource.getResult = channels
        
        try await sut.loadFromLocalStorage()
        
        XCTAssertEqual(localDatasource.getWasCalledTimes, 1)
        XCTAssertEqual(remoteDatasource.wasCalledWith, channels.map(\.url))
    }
    
    func test_loadFromLocalStorage_updatesLocalDatasource_when_localDatasourceHasValues() async throws {
        let channel = Channel(title: "Title 1", description: "Desc 1", url: URL(string: "https://example.com")!)
        let updatedChannel = Channel(title: "Updated title", description: "Desc 2", url: URL(string: "https://example.com")!)

        localDatasource.getResult = [channel]
        remoteDatasource.fetchResult = .success(updatedChannel)
        
        try await sut.loadFromLocalStorage()
        
        XCTAssertEqual(localDatasource.getWasCalledTimes, 1)
        XCTAssertEqual(remoteDatasource.wasCalledWith, [channel].map(\.url))
        XCTAssertEqual(localDatasource.updateWasCalledWith, [updatedChannel])
    }
    
    func test_loadFromLocalStorage_registersTimer_onSuccess() async throws {
        let channel = Channel(title: "Title 1", description: "Desc 1", url: URL(string: "https://example.com")!)
        remoteDatasource.fetchResult = .success(channel)
        localDatasource.getResult = [channel]

        try await sut.loadFromLocalStorage()
        
        XCTAssertEqual(remoteDatasource.wasCalledWith, [channel.url])
        XCTAssertEqual(localDatasource.updateWasCalledWith, [channel])
        XCTAssertEqual(refreshManager.registerAllCalledWith, [channel])
    }
    
    func test_subscribeToFeed_skips_whenAlreadySubscribed() async throws {
        let channel = Channel(title: "Title 1", description: "Desc 1", url: URL(string: "https://example.com")!)

        localDatasource.getResult = [channel]
        
        try await sut.loadFromLocalStorage()
        try await sut.subscribeToFeed(with: channel.url)
        
        XCTAssertEqual(localDatasource.getWasCalledTimes, 1)
        XCTAssertEqual(remoteDatasource.wasCalledWith, [channel.url])
    }
    
    func test_subscribeToFeed_storesChangeInLocalDatasource_onSuccess() async throws {
        let channel = Channel(title: "Title 1", description: "Desc 1", url: URL(string: "https://example.com")!)
        remoteDatasource.fetchResult = .success(channel)

        try await sut.subscribeToFeed(with: channel.url)
        
        XCTAssertEqual(localDatasource.storeWasCalledWith, [channel])
        XCTAssertEqual(remoteDatasource.wasCalledWith, [channel.url])
    }
    
    func test_subscribeToFeed_registersTimer_onSuccess() async throws {
        let channel = Channel(title: "Title 1", description: "Desc 1", url: URL(string: "https://example.com")!)
        remoteDatasource.fetchResult = .success(channel)

        try await sut.subscribeToFeed(with: channel.url)
        
        XCTAssertEqual(localDatasource.storeWasCalledWith, [channel])
        XCTAssertEqual(remoteDatasource.wasCalledWith, [channel.url])
        XCTAssertEqual(refreshManager.registerCalledWith, channel)
    }
    
    func test_refreshAllChannels_updates_allChannels() async throws {
        let channels = [
            Channel(title: "Title 1", description: "Desc 1", url: URL(string: "https://example.com")!),
            Channel(title: "Title 2", description: "Desc 2", url: URL(string: "https://example2.com")!),
        ]
        remoteDatasource.fetchResult = .success(channels[0])
        localDatasource.getResult = channels
        
        try await sut.loadFromLocalStorage()
        XCTAssertEqual(remoteDatasource.wasCalledWith, channels.map(\.url))
        
        try await sut.refreshAllChannels()
        
        XCTAssertEqual(remoteDatasource.wasCalledWith, [
            URL(string: "https://example.com")!,
            URL(string: "https://example2.com")!,
            URL(string: "https://example.com")!,
            URL(string: "https://example2.com")!]
        )
        XCTAssertNil(refreshManager.registerCalledWith)
        XCTAssertEqual(refreshManager.registerAllCalledWith, channels)
        XCTAssertEqual(localDatasource.updateWasCalledWith, [channels[0], channels[0], channels[0], channels[0]])
    }

    func test_deleteChannelRemoves_from_localDatasource() async throws {
        let channel = Channel(title: "Title 1", description: "Desc 1", url: URL(string: "https://example.com")!)
        localDatasource.getResult = [channel]
        
        try await sut.loadFromLocalStorage()
        sut.remove(channel)
        
        XCTAssertEqual(localDatasource.deleteWasCalledWith, [channel])
    }
    
    func test_deleteChannelRemoves_from_refreshManager() async throws {
        let channel = Channel(title: "Title 1", description: "Desc 1", url: URL(string: "https://example.com")!)
        localDatasource.getResult = [channel]
        
        try await sut.loadFromLocalStorage()
        sut.remove(channel)
        
        XCTAssertEqual(localDatasource.deleteWasCalledWith, [channel])
        XCTAssertEqual(refreshManager.unregisterCalledWith, channel)
    }
    
    func test_clearNewArticleDifferences_clearsDifferences() async throws {
        let channels = [Channel(title: "Title 1", description: "Desc 1", url: URL(string: "https://example.com")!)]
        let updatedChannel = Channel(title: "Title 1", description: "Desc 1", articles: [Article(title: "Title", description: "Desc")], url: URL(string: "https://example.com")!)
        localDatasource.getResult = channels
        remoteDatasource.fetchResult = .success(updatedChannel)
        
        try await sut.loadFromLocalStorage()
        
        XCTAssertFalse(sut.articleDifference.isEmpty)
        
        sut.clearNewArticlesCount(for: "https://example.com")
        
        XCTAssertTrue(sut.articleDifference.isEmpty)
    }
}
