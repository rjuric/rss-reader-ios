//
//  LocalChannelDatasource.swift
//  RSS Reader
//
//  Created by rjuric on 26.04.2024..
//

import Foundation

protocol LocalChannelDatasourceProtocol {
    func get() -> [Channel]
    func store(_ channel: Channel)
    func update(_ channel: Channel)
    func delete(_ channel: Channel)
}

struct LocalChannelDatasource: LocalChannelDatasourceProtocol {
    var databaseService: PersistenceServiceProtocol = PersistenceService()
    
    func get() -> [Channel] {
        databaseService.get()
    }
    
    func store(_ channel: Channel) {
        databaseService.store(channel)
    }
    
    func update(_ channel: Channel) {
        databaseService.update(channel)
    }
    
    func delete(_ channel: Channel) {
        databaseService.delete(channel)
    }
}
