//
//  ArticleViewModel.swift
//  RSS Reader
//
//  Created by rjuric on 24.04.2024..
//

import Foundation

struct ArticleViewModel {
    let title: String
    let url: URL
}

extension ArticleViewModel: Equatable {}

extension ArticleViewModel: Hashable {}

extension ArticleViewModel {
    init(from article: Article) {
        title = article.title
        url = article.url
    }
}
