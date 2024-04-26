//
//  LocalChannelDatasource.swift
//  RSS Reader
//
//  Created by rjuric on 26.04.2024..
//

import Foundation

protocol LocalChannelDatasourceProtocol {
    func get() throws -> [Channel]
    func store(_ channel: Channel) throws
    func update(_ channel: Channel) throws
    func delete(_ channel: Channel) throws
}

struct LocalChannelDatasource: LocalChannelDatasourceProtocol {
    var databaseService: DatabaseServiceProtocol = DatabaseService()
    var channelModelToChannelMapper: ChannelModelToChannelMapperProtocol = ChannelModelToChannelMapper()
    var channelToChannelModelMapper: ChannelToChannelModelMapperProtocol = ChannelToChannelModelMapper()
    
    func get() throws -> [Channel] {
        let dbChannels = try databaseService.get(ChannelModel.self)
        return try dbChannels.map(channelModelToChannelMapper.map)
    }
    
    func store(_ channel: Channel) throws {
        let model = channelToChannelModelMapper.map(from: channel)
        try databaseService.store(model)
    }
    
    func update(_ channel: Channel) throws {
        let model = channelToChannelModelMapper.map(from: channel)
        try databaseService.update(model)
    }
    
    func delete(_ channel: Channel) throws {
        let model = channelToChannelModelMapper.map(from: channel)
        try databaseService.delete(model)
    }
}
