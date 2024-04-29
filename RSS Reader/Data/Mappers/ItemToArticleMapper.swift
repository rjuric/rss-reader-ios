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
        
        var imageUrl: URL?
        if [Constants.SupportedMediaTypes.png, Constants.SupportedMediaTypes.jpg, Constants.SupportedMediaTypes.bmp]
            .contains(where: { item.enclosure?.attributes?.type == $0 }),
           let imageUrlString = item.enclosure?.attributes?.url
        {
            imageUrl = URL(string: imageUrlString)
        }
        
        return Article(
            title: title,
            image: imageUrl,
            description: description,
            url: url
        )
    }
}
