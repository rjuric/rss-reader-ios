//
//  Article.swift
//  RSS Reader
//
//  Created by rjuric on 24.04.2024..
//

import Foundation

struct Article {
    let title: String
    let image: URL?
    let description: String
    var url: URL = URL(string: "https://en.wikipedia.org/wiki/Special:Random")!
}

extension Article: Identifiable {
    var id: String {
        title
    }
}

extension Article: Equatable {}
