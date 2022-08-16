//
//  RouterTest.swift
//  ChocoTests
//
//  Created by Mozhgan on 10/1/21.
//

@testable import OnlineShopping
import XCTest

final class LoginRouterTests: XCTestCase {

    private var window: UIWindow!

    // MARK: - Setup / Teardown

    override func setUp() {

        super.setUp()

        window = UIWindow()
    }

    override func tearDown() {

        super.tearDown()

        window = nil
    }

    // MARK: - Tests

    func testNavigateToDashboardShouldBeDisplayed() {
    }
}

// MARK: - NavigationControllerSpy

final class NavigationControllerSpy: UINavigationController {

    var pushedViewController: UIViewController?

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {

        super.pushViewController(viewController, animated: animated)

        pushedViewController = viewController
    }
}
