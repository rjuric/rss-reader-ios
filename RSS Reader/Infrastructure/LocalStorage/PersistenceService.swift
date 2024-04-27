//
//  PersistenceService.swift
//  RSS Reader
//
//  Created by rjuric on 27.04.2024..
//

import Foundation

struct PersistenceService {
    let userDefaults = UserDefaults.standard
    let encoder: JSONEncoder = JSONEncoder()
    let decoder: JSONDecoder = JSONDecoder()
}

extension PersistenceService: ChannelPersistenceServiceProtocol {
    func store(_ channel: Channel) {
        var channels = get()
        channels.insert(channel, at: 0)
        
        let encoded = try? encoder.encode(channels)
        
        userDefaults.setValue(encoded, forKey: Constants.StorageKeys.channelStorage)
    }
    
    func get() -> [Channel] {
        let data = userDefaults.data(forKey: Constants.StorageKeys.channelStorage)
        
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
        
        userDefaults.setValue(encoded, forKey: Constants.StorageKeys.channelStorage)
    }
    
    func delete(_ channel: Channel) {
        var channels = get()
        
        guard let index = channels.firstIndex(where: { $0.id == channel.id }) else { return }
        channels.remove(at: index)
        
        let encoded = try? encoder.encode(channels)
        
        userDefaults.setValue(encoded, forKey: Constants.StorageKeys.channelStorage)
    }
}

extension PersistenceService: AppFlagsPersistenceServiceProtocol {
    func fetch() -> AppFlags? {
        guard let data = userDefaults.data(forKey: Constants.StorageKeys.appFlagsStorage) else {
            return nil
        }
        
        return try? decoder.decode(AppFlags.self, from: data)
    }
    
    func save(_ flags: AppFlags) {
        let encoded = try? encoder.encode(flags)
        
        userDefaults.setValue(encoded, forKey: Constants.StorageKeys.appFlagsStorage)
    }
}
