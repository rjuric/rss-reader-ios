//
//  ChannelModel.swift
//  RSS Reader
//
//  Created by rjuric on 26.04.2024..
//

import Foundation
import RealmSwift

final class ChannelModel: Object {
    @Persisted(primaryKey: true) var url: String
    @Persisted var title: String
    @Persisted var subtitle: String
    @Persisted var image: String?
    @Persisted var isFavorite: Bool
    @Persisted var articles: List<ArticleModel>
}
