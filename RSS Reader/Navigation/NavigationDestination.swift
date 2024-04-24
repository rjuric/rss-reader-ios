//
//  NavigationDestination.swift
//  RSS Reader
//
//  Created by rjuric on 24.04.2024..
//

import Foundation

enum NavigationDestination {
    case rssFeed
    case feedItem
}

extension NavigationDestination: Hashable {}
