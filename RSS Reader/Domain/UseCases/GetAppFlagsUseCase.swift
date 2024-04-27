//
//  GetAppFlagsUseCase.swift
//  RSS Reader
//
//  Created by rjuric on 27.04.2024..
//

import Foundation

protocol GetAppFlagsUseCaseProtocol {
    func execute() -> AppFlags?
}

extension GetAppFlagsUseCaseProtocol {
    func callAsFunction() -> AppFlags? {
        execute()
    }
}

struct GetAppFlagsUseCase: GetAppFlagsUseCaseProtocol {
    var persistenceService: AppFlagsPersistenceServiceProtocol = PersistenceService()
    
    func execute() -> AppFlags? {
        persistenceService.fetch()
    }
}
