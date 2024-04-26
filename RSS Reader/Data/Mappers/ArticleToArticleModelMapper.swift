//
//  ArticleToArticleModelMapper.swift
//  RSS Reader
//
//  Created by rjuric on 26.04.2024..
//

import Foundation

protocol ArticleToArticleModelMapperProtocol {
    func map(from article: Article) -> ArticleModel
}

struct ArticleToArticleModelMapper: ArticleToArticleModelMapperProtocol {
    func map(from article: Article) -> ArticleModel {
        let model = ArticleModel()
        model.title = article.title
        model.subtitle = article.description
        model.image = article.image?.absoluteString
        model.url = article.url.absoluteString
        return model
    }
}
