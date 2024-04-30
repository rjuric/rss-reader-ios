//
//  AppFlagsPersistenceServiceStub.swift
//  RSS ReaderTests
//
//  Created by rjuric on 30.04.2024..
//

import Foundation
@testable import RSS_Reader

final class AppFlagsPersistenceServiceStub: AppFlagsPersistenceServiceProtocol {
    var fetchResult: AppFlags?
    var fetchWasCalled = false
    func fetch() -> AppFlags? {
        fetchWasCalled = true
        return fetchResult
    }
    
    var saveCalledWith: AppFlags?
    var saveWasCalled: Bool {
        !saveCalledWith.isNil
    }
    func save(_ flags: AppFlags) {
        saveCalledWith = flags
    }
}
