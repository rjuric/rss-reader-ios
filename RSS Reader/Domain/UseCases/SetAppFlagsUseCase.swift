//
//  SetAppFlagsUseCase.swift
//  RSS Reader
//
//  Created by rjuric on 27.04.2024..
//

import Foundation

protocol SetAppFlagsUseCaseProtocol {
    func execute(_ flags: AppFlags)
}

extension SetAppFlagsUseCaseProtocol {
    func callAsFunction(_ flags: AppFlags) {
        execute(flags)
    }
}

struct SetAppFlagsUseCase: SetAppFlagsUseCaseProtocol {
    var persistenceService: AppFlagsPersistenceServiceProtocol = PersistenceService()
    
    func execute(_ flags: AppFlags) {
        persistenceService.save(flags)
    }
}
