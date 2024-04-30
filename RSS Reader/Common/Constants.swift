//
//  Constants.swift
//  RSS Reader
//
//  Created by rjuric on 24.04.2024..
//

import Foundation

enum Constants {
    enum SymbolNames {
        static let plus = "plus"
        static let plusInsideCircle = "plus.circle"
        static let star = "star"
        static let starFilled = "star.fill"
        static let trash = "trash"
        static let safari = "safari"
        static let chevronRight = "chevron.forward"
    }
    
    enum TimeIntervals {
        static let minute = 60
        static let minute15 = 15*minute
    }
    
    enum StorageKeys {
        static let channelStorage = "com.rjuric.channel-storage"
        static let appFlagsStorage = "com.rjuric.app-flags-storage"
    }
    
    enum SupportedMediaTypes {
        static let png = "image/png"
        static let jpg = "image/jpeg"
        static let bmp = "image/bmp"
    }
    
    enum SupportedUrlSchemes {
        static let http = "http"
        static let https = "https"
    }
    
    enum Identifiers {
        static let refresh = "com.juricroko.background.refresh"
        static let notification = "com.juricroko.background.notification"
    }
}
