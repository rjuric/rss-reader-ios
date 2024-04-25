//
//  String+isValidUrlString.swift
//  RSS Reader
//
//  Created by rjuric on 25.04.2024..
//

import Foundation

extension String {
    var isValidUrlString: Bool {
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        if let match = detector.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)) {
            return match.range.length == self.utf16.count
        } else {
            return false
        }
    }
}
