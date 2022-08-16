//
//  CustomError.swift
//  Choco
//
//  Created by Mozhgan on 9/27/21.
//

import Foundation

struct ChocoError: LocalizedError {
    var errorDescription: String? { return reason }
    var failureReason: String? { return reason }

    private var reason: String

    init(reason : String) {
        self.reason = reason
    }
}
