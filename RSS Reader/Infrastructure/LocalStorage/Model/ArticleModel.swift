//
//  ArticleModel.swift
//  RSS Reader
//
//  Created by rjuric on 26.04.2024..
//

import Foundation
import RealmSwift

final class ArticleModel: Object {
    @Persisted(primaryKey: true) var url: String
    @Persisted var title: String
    @Persisted var subtitle: String
    @Persisted var image: String?
}
