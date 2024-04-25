//
//  RssFeedFetcher.swift
//  RSS Reader
//
//  Created by rjuric on 25.04.2024..
//

import Foundation
import FeedKit

protocol RssFeedFetcherProtocol {
    func fetch(from url: URL) async throws -> Feed
}

struct RssFeedFetcher: RssFeedFetcherProtocol {
    func fetch(from url: URL) async throws -> Feed {
        let parser = FeedParser(URL: url)
        
        return try await withCheckedThrowingContinuation { continuation in
            parser.parseAsync { result in
                switch result {
                case .success(let channel):
                    continuation.resume(returning: channel)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
        
    }
}
