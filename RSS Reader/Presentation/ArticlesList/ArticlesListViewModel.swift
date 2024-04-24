//
//  ArticlesListViewModel.swift
//  RSS Reader
//
//  Created by rjuric on 24.04.2024..
//

import Foundation

struct ArticlesListViewModel {
    let articles: [Article]
    let publication: String
}

extension ArticlesListViewModel: Equatable {}

extension ArticlesListViewModel: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(publication)
        hasher.combine(articles.count)
    }
}
