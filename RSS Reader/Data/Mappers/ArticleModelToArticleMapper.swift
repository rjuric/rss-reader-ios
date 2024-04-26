//
//  ArticleModelToArticleMapper.swift
//  RSS Reader
//
//  Created by rjuric on 26.04.2024..
//

import Foundation

protocol ArticleModelToArticleMapperProtocol {
    func map(from articleModel: ArticleModel) throws -> Article
}

struct ArticleModelToArticleMapper: ArticleModelToArticleMapperProtocol {
    func map(from articleModel: ArticleModel) throws -> Article {
        guard let articleUrl = URL(string: articleModel.url) else {
            throw DatabaseMappingError.invalidFormat
        }
        
        var imageUrl: URL?
        if let imageUrlString = articleModel.image {
            imageUrl = URL(string: imageUrlString)
        }
   
        return Article(
            title: articleModel.title,
            image: imageUrl,
            description: articleModel.subtitle,
            url: articleUrl
        )
    }
}
