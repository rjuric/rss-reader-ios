//
//  FeedToChannelMapper.swift
//  RSS Reader
//
//  Created by rjuric on 25.04.2024..
//

import Foundation
import FeedKit

protocol FeedToChannelMapperProtocol {
    func map(feed: Feed) throws -> Channel
}

struct FeedToChannelMapper: FeedToChannelMapperProtocol {
    var articleMapper: ItemToArticleMapperProtocol = ItemToArticleMapper()
    
    func map(feed: Feed) throws -> Channel {
        guard let rssFeed = feed.rssFeed else { throw RssReaderError.wrongFeedFormat }
        
        guard let title = rssFeed.title, let description = rssFeed.description else {
            throw RssReaderError.wrongFeedFormat
        }
        
        let articles = try rssFeed.items?.map(articleMapper.map) ?? []
        
        var imageUrl: URL?
        if let linkToImage = rssFeed.image?.url {
            imageUrl = URL(string: linkToImage)
        }
        
        return Channel(
            title: title,
            image: imageUrl,
            description: description,
            isFavorite: false,
            articles: articles
        )
        
        // TODO: cleanup
    }
}
