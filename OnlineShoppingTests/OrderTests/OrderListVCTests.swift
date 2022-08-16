//
//  File.swift
//  ChocoTests
//
//  Created by Mozhgan on 10/17/21.
//

import Foundation
import XCTest
@testable import OnlineShopping
class OrderListVCTests : XCTestCase {
    private var window: UIWindow!
    override func tearDown() {
        super.tearDown()
        window = nil
    }
    override func setUp() {
        super.setUp()
        window = UIWindow()
    }
    func testInitShouldSetViewControllerRouter() {
        let vc = OrderList.Builder.build()
        XCTAssertNotNil(vc.router)
    }
    func testInitShouldSetViewControllerInteractor() {
        let vc = OrderList.Builder.build()
        XCTAssertNotNil(vc.interactor)
    }
    func testInitShouldSetInteractorOutput() {
        let vc = OrderList.Builder.build()
        if let interactor = vc.interactor as? OrderList.Interactor {
            XCTAssertNotNil(interactor.presenter)
        } else {
            XCTFail("\(#file) : \(#line) - there is problem in InitShouldSetViewControllerInteractor")
        }
    }

    func testViewDidLoadShouldSetupTitle() {
        let vc = OrderList.Builder.build()
        loadView(window: window, viewController: vc)
        XCTAssertEqual(vc.title, R.string.product.titlePage())
    }

    func testLoadViewShouldSetupRefreshControl() {
        let vc = OrderList.Builder.build()
        loadView(window: window, viewController: vc)
        let refreshCtrl = vc.refreshCtrl
        XCTAssertNotNil(refreshCtrl)
    }

    func testViewDidLoadShouldFetchProducts() {
        // Given
        let vc = OrderListVC()
        let interactor = OrdersInteractorSpy()
        vc.interactor = interactor
        // When
        loadView(window: window, viewController: vc)
        // Then
        XCTAssertTrue(interactor.fetchProductsCalled)
    }
    func testNumberOfSectionsInTableViewShouldAlwaysBeOne() {
        // Given
        let vc = OrderListVC()
        // When
        let numberOfSections = vc.numberOfSections(in: vc.tableView)
        // Then
        XCTAssertEqual(numberOfSections, 1)
    }
    func testNumberOfRowsInAnySectionShouldEqualNumberOfProductsToDisplay() {
        // Given
        let vc = OrderListVC()
        let tableView = vc.tableView!
        let viewModel = OrderList.OrdersViewModel(orders : [OrderList.ProductOrderViewModel(product: OrderList.ProductViewModel(name : Product.apple.name,
                                                                                                                                photo : nil,
                                                                                                                                price : Product.apple.price.formmatedPrice(),
                                                                                                                                id : Product.apple.id),
                                                                                            totalPrice: "0.0" )])
        vc.show(viewModel : viewModel)
        // When
        let numberOfRows = vc.tableView(tableView, numberOfRowsInSection: 0)
        // Then
        XCTAssertEqual(numberOfRows, 1)
    }

    func testCellForRowAtIndexShouldConfigureTableViewCellToDisplayProducts() {
        // Given
        let vc = OrderListVC()
        let tableView = vc.tableView!

        let viewModel = OrderList.OrdersViewModel(orders : [OrderList.ProductOrderViewModel(product: OrderList.ProductViewModel(name : Product.apple.name,
                                                                                                                                photo : nil,
                                                                                                                                price : Product.apple.price.formmatedPrice(),
                                                                                                                                id : Product.apple.id),
                                                                                            totalPrice: "0.0" )])
        vc.show(viewModel : viewModel)
        // When
        loadView(window: window, viewController: vc)
        // Then
        let indexPath = IndexPath(row: 0, section: 0)
        if let cell = vc.tableView(tableView, cellForRowAt: indexPath) as? ProductCell {
            XCTAssertEqual(cell.nameLbl.text, Product.apple.name)
        } else {
            XCTFail("\(#file) : \(#line) - there is problem in testCellForRowAtIndexShouldConfigureTableViewCellToDisplayProducts")
        }
    }
    func testDidSelectRowAtIndexShouldNavigateToProduct() {

        // Given
        let vc = OrderListVC()
        let tableView = vc.tableView!
        let viewModel = OrderList.OrdersViewModel(orders : [OrderList.ProductOrderViewModel(product: OrderList.ProductViewModel(name : Product.apple.name,
                                                                                                                                photo : nil,
                                                                                                                                price : Product.apple.price.formmatedPrice(),
                                                                                                                                id : Product.apple.id),
                                                                                            totalPrice: "0.0" )])
        vc.show(viewModel : viewModel)
        // When
        loadView(window: window, viewController: vc)
        let indexPath = IndexPath(row: 0, section: 0)
        if let cell = vc.tableView(tableView, cellForRowAt: indexPath) as? ProductCell {
            XCTAssertEqual(cell.nameLbl.text, Product.apple.name)
        } else {
            XCTFail("\(#file) : \(#line) - there is problem in testDidSelectRowAtIndexShouldNavigateToProduct")
        }
    }
    func testRefreshShouldFetchProducts() {

        // Given
        let vc = OrderListVC()

        let interactor = OrdersInteractorSpy()
        vc.interactor = interactor
        // When
        vc.refresh(sender: vc.refreshCtrl)
        // Then
        XCTAssertTrue(interactor.fetchProductsCalled)
    }
    func testStepperShouldChangeTheQuantity() {
        let expectation = XCTestExpectation(description: "Update Cart")
        // Given
        let vc = OrderListVC()
        let tableView = vc.tableView!
        let interactor = OrdersInteractorSpy()
        vc.interactor = interactor
        let viewModel = OrderList.OrdersViewModel(orders : [OrderList.ProductOrderViewModel(product: OrderList.ProductViewModel(name : Product.apple.name,
                                                                                                                                photo : nil,
                                                                                                                                price : Product.apple.price.formmatedPrice(),
                                                                                                                                id : Product.apple.id),
                                                                                            totalPrice: "0.0" )])
        vc.show(viewModel : viewModel)
        // When
        loadView(window: window, viewController: vc)
        // Then
        let indexPath = IndexPath(row: 0, section: 0)
        if let cell = vc.tableView(tableView, cellForRowAt: indexPath) as? ProductCell {
            let delegate = StepperDelegate(callback: { value in
                                                interactor.updateOrder(index: indexPath.row, value: value)
                                                expectation.fulfill()
                                                XCTAssertTrue(interactor.shoppingCartWasUpdated)
                                            })
            let fakeStepper = UIStepper()
            fakeStepper.value = 2
            cell.configCell(viewModel : viewModel.orders[indexPath.row],delegate : delegate)
            cell.orderStepper.stepperValueChanged(fakeStepper)
            _ =  XCTWaiter.wait(for: [expectation], timeout: 10.0)
        } else {
            XCTFail("\(#file) : \(#line) - there is problem in testCellForRowAtIndexShouldConfigureTableViewCellToDisplayProducts")
        }
    }
}

class OrdersInteractorSpy : OrderListBusinessLogic,OrderListDataSource {
    var orders: [ProductOrder] = []
    var products: [Product] = []
    var fetchProductsCalled = false
    var shoppingCartWasUpdated = false
    func fetchProducts() {
        fetchProductsCalled = true
    }
    func updateOrder(index: Int, value: Int) {
        shoppingCartWasUpdated = true
    }
}

class OrdersRouterSpy : OrderListRouterLogic,OrderListRouterDataPassing {
    var dataStore: OrderListDataSource?
    var navigateToDetailCalled = false
    func naviagteToDetail(index: Int) {
        navigateToDetailCalled = true
    }
    func logout() {
    }
}

class StepperDelegate : ProductCellDelegate {
    var callback : (Int) -> Void
    init(callback : @escaping  (Int) -> Void) {
        self.callback = callback
    }
    func update(cell: ProductCell?, value: Int) {
        self.callback(value)
    }
}
