//
//  OrderRepository.swift
//  Choco
//
//  Created by Mozhgan on 10/4/21.
//

import Foundation
import Combine

public enum PersistStoreError: Error {
    case unhandledError(message: String)
    case notFound
}
public protocol OrderRepository {
    var storageContext : StorageContext? { get set }
    func insert(product: Product) -> Future<ProductOrder,Error>
    func incrementProduct(with id: String) -> Future<ProductOrder,Error>
    func decrementProduct(with id: String) -> Future<ProductOrder?,Error>
    func clearCache() -> Future<Bool,Error>
    func fetchOrders() -> Future<[ProductOrder],Error>
}
final public class LocalOrderRepository : OrderRepository {

    public var storageContext: StorageContext?
    init(storage: StorageContext? = defaultRealmStorage) {
        self.storageContext = storage
    }

    public func insert(product: Product) -> Future<ProductOrder,Error> {
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

    public func incrementProduct(with id: String) -> Future<ProductOrder,Error> {
        if let product = storageContext?.fetch(Product.self, predicate: NSPredicate(format: "id = %@", id),sorted: nil).first,
              let order = storageContext?.fetch(ProductOrder.self, predicate: NSPredicate(format: "id = %@", id),sorted: nil).first {
            do {
                let newOrder = ProductOrder(product: product, quantity: order.quantity + 1)
                try storageContext?.save(object: newOrder)
                return Future<ProductOrder, Error> { promise in
                    promise(.success(newOrder))
                }
            } catch let error {
                return Future<ProductOrder, Error> { promise in
                    promise(.failure(error))
                }
            }
        } else {
            return Future<ProductOrder, Error> { promise in
                promise(.failure(PersistStoreError.notFound))
            }
        }
    }

    public func decrementProduct(with id: String) -> Future<ProductOrder?,Error> {
        if let product = storageContext?.fetch(Product.self, predicate: NSPredicate(format: "id = %@", id),sorted: nil).first,
              let order = storageContext?.fetch(ProductOrder.self, predicate: NSPredicate(format: "id = %@", id),sorted: nil).first {
            do {
                if order.quantity - 1 == 0 {
                    try storageContext?.delete(object: order)
                    return Future<ProductOrder?, Error> { promise in
                        promise(.success(nil))
                    }
                } else {
                    let newOrder = ProductOrder(product: product, quantity: order.quantity - 1)
                    try storageContext?.save(object: newOrder )
                    return Future<ProductOrder?, Error> { promise in
                        promise(.success(newOrder))
                    }
                }

            } catch let error {
                return Future<ProductOrder?, Error> { promise in
                    promise(.failure(error))
                }
            }
        } else {
            return Future<ProductOrder?, Error> { promise in
                promise(.failure(PersistStoreError.notFound))
            }
        }
    }

    public func clearCache() -> Future<Bool, Error> {
        do {
            try self.storageContext?.deleteAll(ProductOrder.self)
            return Future<Bool, Error> { promise in
                promise(.success(true))
            }
        } catch let error {
            return Future<Bool, Error> { promise in
                promise(.failure(error))
            }
        }
    }

    public func fetchOrders() -> Future<[ProductOrder], Error> {
        return Future<[ProductOrder], Error> { promise in
            let orders = self.storageContext?.fetch(ProductOrder.self,
                                                    predicate: nil,
                                                    sorted: nil)
            promise(.success(orders ?? []))
        }
    }
}
