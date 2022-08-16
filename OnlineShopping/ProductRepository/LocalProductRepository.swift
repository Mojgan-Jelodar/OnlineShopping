//
//  LocalProductRepository.swift
//  Choco
//
//  Created by Mozhgan on 9/27/21.
//

import Foundation
import Combine

protocol LocalProductRepositoryProtocol : ProductRepository {
    var storageContext : StorageContext? { get set }
    func save(products : [Product]) throws
    func clearCache() throws
}
struct LocalProductRepository : LocalProductRepositoryProtocol {
    var storageContext: StorageContext?
    init(storage: StorageContext? = defaultRealmStorage) {
        self.storageContext = storage
    }

    func fetchProducts() -> Future<ProductNetworkModel.ProductsResponse, Error> {
        return Future<ProductNetworkModel.ProductsResponse, Error> { promise in
            let products = storageContext?.fetch(Product.self,
                                predicate: nil,
                                sorted: Sorted(key: "name",ascending : true))
            promise(.success(products ?? []))
        }
    }
    func save(products: ProductNetworkModel.ProductsResponse) throws {
        for product in products {
            try storageContext?.save(object: product.with())
        }
    }

    func clearCache() throws {
        try storageContext?.deleteAll(Product.self)
    }
}
