//
//  ChannelRepositoryStub.swift
//  RSS ReaderTests
//
//  Created by rjuric on 30.04.2024..
//

import Foundation
import Combine
@testable import RSS_Reader

final class ChannelRepositoryStub: ChannelRepositoryProtocol {
    var updateCalledWith: [Channel] = []
    var updateCalled: Bool {
        !updateCalledWith.isEmpty
    }
    func update(_ channel: Channel) {
        updateCalledWith.append(channel)
    }
    
    var loadFromLocalStorageResult: Result<Void, Error> = .success(Void())
    var loadFromLocalStorageCallsCount: Int = 0
    func loadFromLocalStorage() async throws {
        loadFromLocalStorageCallsCount += 1
        return try loadFromLocalStorageResult.get()
    }
    
    var subscribeToFeedReturnValue: Result<Void, Error> = .success(Void())
    var subscribeToFeedCalledWith: [URL] = []
    var subscribeToFeedCalled: Bool {
        !subscribeToFeedCalledWith.isEmpty
    }
    func subscribeToFeed(with feedUrl: URL) async throws {
        subscribeToFeedCalledWith.append(feedUrl)
        return try subscribeToFeedReturnValue.get()
    }
    
    var removeCalledFor: [Channel] = []
    var removeCalled: Bool {
        !removeCalledFor.isEmpty
    }
    func remove(_ channel: Channel) {
        removeCalledFor.append(channel)
    }
    
    var refreshAllChannelsResult: Result<Void, Error> = .success(Void())
    var refreshAllChannelsCallsCount: Int = 0
    func refreshAllChannels() async throws {
        refreshAllChannelsCallsCount += 1
        return try refreshAllChannelsResult.get()
    }
    
    var refreshCalledWith: [Channel] = []
    var refreshCalled: Bool {
        !refreshCalledWith.isEmpty
    }
    func refresh(_ channel: Channel) async throws {
        refreshCalledWith.append(channel)
    }
    
    var getNewArticlesCountCalledWith: [String] = []
    var getNewArticlesCountCalled: Bool {
        !getNewArticlesCountCalledWith.isEmpty
    }
    func getNewArticlesCount(for channelId: String) -> Int {
        getNewArticlesCountCalledWith.append(channelId)
        return 0
    }
    
    var clearNewArticlesCountCalledWith: [String] = []
    var clearNewArticlesCountCalled: Bool {
        !clearNewArticlesCountCalledWith.isEmpty
    }
    func clearNewArticlesCount(for channelId: String) {
        clearNewArticlesCountCalledWith.append(channelId)
    }
    
    var articleCountCallsCount: Int = 0
    var articleDifference: [String : Int] {
        articleCountCallsCount += 1
        return [:]
    }
    
    var channelPublisherCallsCount: Int = 0
    var channelSubject = CurrentValueSubject<[Channel], Never>([])
    var channelPublisher: AnyPublisher<[Channel], Never> {
        channelPublisherCallsCount += 1
        return channelSubject.eraseToAnyPublisher()
    }
    
    var articleCountPublisherCallsCount: Int = 0
    var articleCountSubject = CurrentValueSubject<[String : Int], Never>([:])
    var articleCountPublisher: AnyPublisher<[String : Int], Never> {
        articleCountPublisherCallsCount += 1
        return articleCountSubject.eraseToAnyPublisher()
    }
}
