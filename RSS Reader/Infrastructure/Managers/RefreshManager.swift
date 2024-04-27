//
//  RefreshManager.swift
//  RSS Reader
//
//  Created by rjuric on 27.04.2024..
//

import Foundation

protocol RefreshManagerProtocol {
    func registerAll(_ channels: [Channel])
    func register(_ channel: Channel)
    func unregister(_ channel: Channel)
    
    var channelRepository: ChannelRepositoryProtocol? { get set }
}

final class RefreshManager: RefreshManagerProtocol {
    weak var channelRepository: ChannelRepositoryProtocol?
    
    private var timers: [String: Timer] = [:]
    private var timerInterval: TimeInterval {
        #if DEBUG
        Double(Constants.TimeIntervals.minute)
        #else
        Double(Constants.TimeIntervals.minute15)
        #endif
    }
    
    func registerAll(_ channels: [Channel]) {
        channels.forEach(register)
    }
    
    func register(_ channel: Channel) {
        let timer = Timer.scheduledTimer(
            timeInterval: timerInterval,
            target: self,
            selector: #selector(onTimerFire),
            userInfo: ["channel": channel],
            repeats: true
        )
        timers[channel.id] = timer
    }
    
    func unregister(_ channel: Channel) {
        timers[channel.id]?.invalidate()
        timers.removeValue(forKey: channel.id)
    }
    
    @objc func onTimerFire(timer: Timer) {
        guard let userInfo = timer.userInfo as? [String: Channel],
              let channel = userInfo["channel"]
        else {
            timer.invalidate()
            return
        }
        
        Task {
            try? await channelRepository?.refresh(channel)
        }
    }
}
