//
//  OrderLisrRouter.swift
//  ChocoTests
//
//  Created by Mozhgan on 10/19/21.
//

import Foundation
import XCTest
@testable import OnlineShopping
class OrderLisrRouterTests: XCTestCase {
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

    func testNavigateToProductShouldDisplayProductDetail() {

        // Given
        let vc = OrderListVC()
        let navigationControllerSpy = NavigationControllerSpy(rootViewController: vc)
        let interactor = OrdersInteractorSpy()
        interactor.products = [Product.apple,Product.beer]
        let router = OrderList.Router(viewcontroller: vc)
        router.dataStore = interactor
        vc.interactor = interactor
        loadView(window: window, viewController: navigationControllerSpy)
        // When
        let indexPath = IndexPath(row: 0, section: 0)
        router.naviagteToDetail(index: indexPath.row)
        // Then
        if let detailViewController = UIApplication.topViewController(base: vc) as? OrderDetailVC {
            XCTAssertEqual(detailViewController.interactor?.order.id, Product.apple.id)
            XCTAssertEqual(detailViewController.interactor?.order.product.name, Product.apple.name)

        } else {
            XCTFail("\(#file) : \(#line) - there is problem in testNavigateToProductShouldDisplayProductDetail")
        }
    }
}
