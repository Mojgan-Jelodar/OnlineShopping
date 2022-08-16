//
//  XCTestCase.swift
//  ChocoTests
//
//  Created by Mozhgan on 9/30/21.
//

import Foundation
import UIKit
import XCTest

/// Extension of _XCTestCase_ for loading view controller

extension XCTestCase {

    // MARK: - Load view

    func loadView(window: UIWindow, viewController: UIViewController) {

        window.addSubview(viewController.view)
        RunLoop.current.run(until: Date())
    }
}
