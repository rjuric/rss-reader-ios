//
//  ArticleCountChannel.swift
//  RSS Reader
//
//  Created by rjuric on 29.04.2024..
//

import Foundation

struct ArticleCountChannel {
    let channel: Channel
    let articleCount: Int
}

extension ArticleCountChannel: Identifiable {
    var id: String {
        channel.id
    }
}
