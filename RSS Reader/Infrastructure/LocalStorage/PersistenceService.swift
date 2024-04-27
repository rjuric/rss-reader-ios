//
//  PersistenceService.swift
//  RSS Reader
//
//  Created by rjuric on 27.04.2024..
//

import Foundation

protocol PersistenceServiceProtocol {
    func store(_ channel: Channel)
    func get() -> [Channel]
    func update(_ channel: Channel)
    func delete(_ channel: Channel)
}

struct PersistenceService: PersistenceServiceProtocol {
    let userDefaults = UserDefaults.standard
    let encoder: JSONEncoder = JSONEncoder()
    let decoder: JSONDecoder = JSONDecoder()
    
    func store(_ channel: Channel) {
        var channels = get()
        channels.insert(channel, at: 0)
        
        let encoded = try? encoder.encode(channels)
        
        userDefaults.setValue(encoded, forKey: "com.rjuric.channel-storage")
    }
    
    func get() -> [Channel] {
        let data = userDefaults.data(forKey: "com.rjuric.channel-storage")
        
        guard let data, let channels = try? decoder.decode([Channel].self, from: data) else {
            return []
        }
        
        return channels
    }
    
    func update(_ channel: Channel) {
        var channels = get()
        
        guard let index = channels.firstIndex(where: { $0.id == channel.id }) else { return }
        channels[index] = channel
        
        let encoded = try? encoder.encode(channels)
        
        userDefaults.setValue(encoded, forKey: "com.rjuric.channel-storage")
    }
    
    func delete(_ channel: Channel) {
        var channels = get()
        
        guard let index = channels.firstIndex(where: { $0.id == channel.id }) else { return }
        channels.remove(at: index)
        
        let encoded = try? encoder.encode(channels)
        
        userDefaults.setValue(encoded, forKey: "com.rjuric.channel-storage")
    }
}
