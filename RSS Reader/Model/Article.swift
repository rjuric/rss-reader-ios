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
}

extension Article: Identifiable {
    var id: String {
        title
    }
}

extension Article: Equatable {}
