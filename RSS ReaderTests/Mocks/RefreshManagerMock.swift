//
//  RefreshManagerMock.swift
//  RSS ReaderTests
//
//  Created by rjuric on 30.04.2024..
//

import Foundation
@testable import RSS_Reader

final class RefreshManagerMock: RefreshManagerProtocol {
    weak var channelRepository: ChannelRepositoryProtocol?
    
    init(channelRepository: ChannelRepositoryProtocol? = nil) {
        self.channelRepository = channelRepository
    }
    
    var registerCalledWith: Channel?
    func register(_ channel: Channel) {
        registerCalledWith = channel
    }
    
    var registerAllCalledWith: [Channel]?
    func registerAll(_ channels: [Channel]) {
        registerAllCalledWith = channels
    }
    
    var unregisterCalledWith: Channel?
    func unregister(_ channel: Channel) {
        unregisterCalledWith = channel
    }
}
