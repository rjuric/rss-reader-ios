//
//  RemoteChannelDatasourceStub.swift
//  RSS ReaderTests
//
//  Created by rjuric on 30.04.2024..
//

import Foundation
@testable import RSS_Reader

final class RemoteChannelDatasourceStub: RemoteChannelDatasourceProtocol {
    var fetchResult: Result<Channel, Error> = .success(Channel(title: "Default", description: "Default", url: URL(string: "https://example.com")!))
    var wasCalledWith: [URL] = []
    func fetch(from channelUrl: URL, isFavorite: Bool) async throws -> Channel {
        wasCalledWith.append(channelUrl)
        return try fetchResult.get()
    }
}
