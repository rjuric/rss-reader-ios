//
//  RequestNotificationAuthorizationUseCaseStub.swift
//  RSS ReaderTests
//
//  Created by rjuric on 30.04.2024..
//

import Foundation
@testable import RSS_Reader

final class RequestNotificationAuthorizationUseCaseStub: RequestNotificationAuthorizationUseCaseProtocol {
    var wasCalled = false
    func execute() async {
        wasCalled = true
    }
}
