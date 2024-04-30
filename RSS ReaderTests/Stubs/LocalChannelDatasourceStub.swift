//
//  LocalChannelDatasourceStub.swift
//  RSS ReaderTests
//
//  Created by rjuric on 30.04.2024..
//

import Foundation
@testable import RSS_Reader

final class LocalChannelDatasourceStub: LocalChannelDatasourceProtocol {
    var getResult: [Channel] = []
    var getWasCalledTimes = 0
    func get() -> [Channel] {
        getWasCalledTimes += 1
        return getResult
    }
    
    var storeWasCalledWith: [Channel] = []
    func store(_ channel: Channel) {
        storeWasCalledWith.append(channel)
    }
    
    var deleteWasCalledWith: [Channel] = []
    func delete(_ channel: Channel) {
        deleteWasCalledWith.append(channel)
    }
    
    var updateWasCalledWith: [Channel] = []
    func update(_ channel: Channel) {
        updateWasCalledWith.append(channel)
    }
}
