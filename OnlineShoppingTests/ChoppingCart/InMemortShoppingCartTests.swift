//
//  File.swift
//  ChocoTests
//
//  Created by Mozhgan on 10/1/21.
//

import Foundation
import XCTest
import Combine
@testable import OnlineShopping

class InMemoryShoppingCartTests: XCTestCase {
    private var cart: InMemoryShopingCart!
    private var cancellable: Set<AnyCancellable>!
    override func setUp() {
        self.cart = InMemoryShopingCart()
        self.cancellable = Set<AnyCancellable>()
    }
    override func tearDown() {
        self.cart = nil
        self.cancellable = nil
    }
    func triggerCartActions(_ actions: CartAction...) {
        Publishers.Sequence<[CartAction], Error>(sequence: actions)
            .receive(subscriber: cart.input)
    }

    func testInsertingProduct() {
        let expectation = XCTestExpectation(description: "Inserting new product")
        cart
            .orders
            .sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }, receiveValue: { orders in
            let expectedOrder = ProductOrder(product: Product.apple)
            let isValidInsertion = orders.contains(where: {$0.id == expectedOrder.id && $0.quantity == expectedOrder.quantity})
            XCTAssert(isValidInsertion)
            expectation.fulfill()
        }).store(in: &cancellable)
        triggerCartActions(.insert(product: .apple))
    }
    func testIncrementingProduct() {
        let expectation = XCTestExpectation(description: "Incrementing existing product")
        cart
            .orders
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                }
            }, receiveValue: { orders in
                if orders.contains(where: {$0.id == Product.beer.id && $0.quantity == 2}) {
                    expectation.fulfill()
                }
            }).store(in: &cancellable)
        triggerCartActions(
            .insert(product: .apple),
            .insert(product: .beer),
            .incrementProduct(withId: Product.beer.id ?? "xyz")
        )
    }
}
