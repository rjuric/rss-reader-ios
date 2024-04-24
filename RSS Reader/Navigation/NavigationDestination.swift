//
//  NavigationDestination.swift
//  RSS Reader
//
//  Created by rjuric on 24.04.2024..
//

import Foundation

enum NavigationDestination {
    case feedArticles(ArticlesListViewModel)
    case article
}

extension NavigationDestination: Hashable {}
