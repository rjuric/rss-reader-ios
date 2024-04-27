//
//  AppFlagsPersistenceService.swift
//  RSS Reader
//
//  Created by rjuric on 27.04.2024..
//

import Foundation

protocol AppFlagsPersistenceServiceProtocol {
    func save(_ flags: AppFlags)
    func fetch() -> AppFlags?
}
