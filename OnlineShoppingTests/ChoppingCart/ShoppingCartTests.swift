//
//  LocalMemoryShoppingCartTests.swift
//  ChocoTests
//
//  Created by Mozhgan on 10/15/21.
//

import Foundation
import XCTest
import Combine
import RealmSwift
@testable import OnlineShopping

fileprivate extension ProductOrder {
    static var orders : [Storable] = []
}
public enum StoreError: Error {
  case notFound
}
// swiftlint:disable force_cast
// swiftlint:disable force_try
class ShoppingCartTests: XCTestCase {
    var shoppingCart : ShoppingCart!
    override func setUp() {
        shoppingCart = ShoppingCart(repository: LocalOrderRepositorySpy(storageContext: StorageContextSpy<ProductOrder>()))
    }
    override func tearDown() {
        shoppingCart = nil
    }

    func testInsertingProduct() {
        let expectation = XCTestExpectation(description: "Inserting new product")
        var cancellable : Set<AnyCancellable> = Set<AnyCancellable>()
        shoppingCart
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
        shoppingCart.insert(product: Product.apple)
    }
    func testIncrementingProduct() {
        let expectation = XCTestExpectation(description: "Incrementing existing product")
        var cancellable : Set<AnyCancellable> = Set<AnyCancellable>()
        shoppingCart
            .orders
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                }
            }, receiveValue: { orders in
                if orders.contains(where: {$0.id == Product.apple.id && $0.quantity == 2}) {
                    expectation.fulfill()
                }
            }).store(in: &cancellable)
        shoppingCart.insert(product: Product.apple)
        shoppingCart.insert(product: Product.beer)
        shoppingCart.incrementProduct(with: Product.apple.id ?? "xyz")
    }
    func testDecrementingProduct() {
        let expectation = XCTestExpectation(description: "Decrementing existing product")
        var cancellable : Set<AnyCancellable> = Set<AnyCancellable>()
        shoppingCart
            .orders
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                }
            }, receiveValue: { orders in
                if orders.contains(where: {$0.id == Product.apple.id && $0.quantity == 1}) {
                    expectation.fulfill()
                }
            }).store(in: &cancellable)
        shoppingCart.insert(product: Product.apple)
        shoppingCart.incrementProduct(with: Product.apple.id ?? "xyz")
        shoppingCart.insert(product: Product.beer)
        shoppingCart.decrementProduct(with: Product.apple.id ?? "xyz")
    }
    func testClearCart() {
        let expectation = XCTestExpectation(description: "Clear basket")
        var cancellable : Set<AnyCancellable> = Set<AnyCancellable>()
        shoppingCart
            .orders
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                }
            }, receiveValue: { orders in
                if orders.count == 0 {
                    expectation.fulfill()
                }
            }).store(in: &cancellable)
        shoppingCart.insert(product: Product.apple)
        shoppingCart.insert(product: Product.beer)
        shoppingCart.incrementProduct(with: Product.apple.id ?? "xyz")
        shoppingCart.clear()

    }
}
struct LocalOrderRepositorySpy : OrderRepository {
    var storageContext: StorageContext?
    func insert(product: Product) -> Future<ProductOrder, Error> {
        do {
            let order = ProductOrder(product: product, quantity: 1)
            try storageContext?.save(object: order)
            return Future<ProductOrder, Error> { promise in
                promise(.success(order))
            }
        } catch let error {
            return Future<ProductOrder, Error> { promise in
                promise(.failure(error))
            }
        }

    }
    func incrementProduct(with id: String) -> Future<ProductOrder, Error> {
        guard let order = storageContext?.fetch(ProductOrder.self, predicate: nil, sorted: nil).filter({$0.id == id}).first?.incremented
        else {
            return Future<ProductOrder, Error> { promise in
                promise(.failure(StoreError.notFound))
            }
        }
        try! storageContext?.save(object: order)
        return Future<ProductOrder, Error> { promise in
            promise(.success(order))
        }

    }
    func decrementProduct(with id: String) -> Future<ProductOrder?, Error> {
        guard let order = storageContext?.fetch(ProductOrder.self, predicate: nil, sorted: nil).filter({$0.id == id}).first?.decremented
        else {
            return Future<ProductOrder?, Error> { promise in
                promise(.failure(StoreError.notFound))
            }
        }
        if order.quantity == 0 {
            try! storageContext?.delete(object: order)
            return Future<ProductOrder?, Error> { promise in
                promise(.success(nil))
            }
        }
        return Future<ProductOrder?, Error> { promise in
            promise(.success(order))
        }
    }
    func clearCache() -> Future<Bool, Error> {
        try! storageContext?.deleteAll(ProductOrder.self)
        return Future<Bool, Error> { promise in
            promise(.success(true))
        }

    }
    func fetchOrders() -> Future<[ProductOrder], Error> {
        let orders = storageContext?.fetch(ProductOrder.self, predicate: nil, sorted: nil)
        return Future<[ProductOrder], Error> { promise in
            promise(.success(orders ?? []))
        }
    }
}

class StorageContextSpy<T: Storable> : StorageContext {
    private var isUpdated = false
    func create<T>(_ model: T.Type, completion: @escaping ((T) -> Void)) throws where T : Storable {
    }
    func save(object: Storable) throws {
        guard let index = ProductOrder.orders.lastIndex(where: {($0 as! Object) == (object as! Object)}) else {
            ProductOrder.orders.append(object)
            return
        }
        ProductOrder.orders[index] = object
    }
    func save(objects: [Storable]) throws {
        try objects.forEach({ try self.save(object: $0)})
    }
    func update(block: @escaping () -> Void) throws {
        isUpdated = true
        block()
    }
    func delete(object: Storable) throws {
        guard let index = ProductOrder.orders.lastIndex(where: {($0 as! Object) == (object as! Object)}) else {
            return
        }
        ProductOrder.orders.remove(at: index)
    }
    func deleteAll<T>(_ model: T.Type) throws where T : Storable {
        ProductOrder.orders.removeAll()
    }
    func fetch<T>(_ model: T.Type, predicate: NSPredicate? = nil, sorted: Sorted? = nil) -> [T] where T : Storable {
        return ProductOrder.orders as! [T]
    }
}
