//
//  ChannelPersistenceService.swift
//  RSS Reader
//
//  Created by rjuric on 27.04.2024..
//

import Foundation

protocol ChannelPersistenceServiceProtocol {
    func store(_ channel: Channel)
    func get() -> [Channel]
    func update(_ channel: Channel)
    func delete(_ channel: Channel)
}
