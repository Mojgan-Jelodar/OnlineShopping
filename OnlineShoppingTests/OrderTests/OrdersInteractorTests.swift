//
//  OrdersInteractorTests.swift
//  ChocoTests
//
//  Created by Mozhgan on 10/19/21.
//

import Foundation
import XCTest
import Combine
@testable import OnlineShopping

class OrdersInteractorTests: XCTestCase {
    var cancellable : Set<AnyCancellable>?
    override  func setUp() {
        cancellable = Set<AnyCancellable>()
    }
    override func tearDown() {
        cancellable = nil
    }
    // MARK: - Tests

    func testFetchProductsShouldAskProductWorkerToFetchProducts() {
        // Given
        let presenter = OrdersPresenterSpy()
        let workerSpy = ProductWorkerSpy()
        let interactor = OrderList.Interactor(productWorker: workerSpy, presenter: presenter)
        // When
        interactor.fetchProducts()
        // Then
        XCTAssertTrue(workerSpy.fetchProductsCalled)
    }
    func testFetchProductsShouldAskPresenterToFormatResult() {
        // Given
        let presenter = OrdersPresenterSpy()
        let workerSpy = ProductWorkerSpy()
        let interactor = OrderList.Interactor(productWorker: workerSpy, presenter: presenter)
        // When
        interactor.fetchProducts()
        // Then
        XCTAssertTrue(presenter.presentProductsCalled)
        XCTAssertFalse(presenter.presentErrorCalled)
    }
    func testFetchArtistsShouldAskPresenterToPresentErrorIfError() {

        // Given
        let presenter = OrdersPresenterSpy()
        let workerSpy = ProductWorkerSpy()
        let interactor = OrderList.Interactor(productWorker: workerSpy, presenter: presenter)
        workerSpy.fetchProductsError = true
        // When
        interactor.fetchProducts()
        // Then
        XCTAssertTrue(presenter.presentErrorCalled)
        XCTAssertFalse(presenter.presentProductsCalled)
    }
}

// MARK: - ProductWorkerSpy

final class ProductWorkerSpy: ProductRepository {
    var fetchProductsError = false
    var fetchProductsCalled = false
    enum ProductsWorkerSpyError: Error {

        case generic
    }
    func fetchProducts() -> Future<ProductNetworkModel.ProductsResponse, Error> {
        fetchProductsCalled = true
        if !fetchProductsError {
            return Future { promise in
                promise(.success(ProductNetworkModel.ProductsResponse(arrayLiteral: Product.apple,Product.beer)))
            }
        } else {
            return Future { promise in
                promise(.failure(ProductsWorkerSpyError.generic))
            }
        }
    }

}

// MARK: - OrdersPresenterSpy
final class OrdersPresenterSpy: OrdersPresentationLogic {
    var viewController: OrdersDisplayLogic?
    var presentErrorCalled = false
    var presentProductsCalled = false
    func fetchedBy(error: Error) {
        presentErrorCalled = true
    }
    func fetched(products: [Product], orders: [ProductOrder]) {
        presentProductsCalled = true
    }
}
