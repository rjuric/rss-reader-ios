//
//  ItemToArticleMapper.swift
//  RSS Reader
//
//  Created by rjuric on 25.04.2024..
//

import Foundation
import FeedKit

protocol ItemToArticleMapperProtocol {
    func map(item: RSSFeedItem) throws -> Article
}

struct ItemToArticleMapper: ItemToArticleMapperProtocol {
    func map(item: RSSFeedItem) throws -> Article {
        guard let title = item.title,
              let description = item.description,
              let urlString = item.link,
              let url = URL(string: urlString)
        else {
            throw RssReaderError.wrongFeedFormat
        }
        
        return Article(
            title: title,
            image: nil,
            description: description,
            url: url
        )
        
        // TODO: figure out image
    }
}
