//
//  ProductRepository.swift
//  Choco
//
//  Created by Mozhgan on 9/27/21.
//

import Foundation
import Combine
protocol ProductRepository {
    func fetchProducts() -> Future<ProductNetworkModel.ProductsResponse,Error>
}
struct ProductListWorker : ProductRepository {
    let local : LocalProductRepositoryProtocol
    let network : RemoteProductRepositoryProtocol

    func fetchProducts() -> Future<ProductNetworkModel.ProductsResponse, Error> {
        return Future { promise in
            var cancellable: AnyCancellable?
            cancellable = network.fetchProducts().catch { _ in
                local.fetchProducts()
            }.sink(receiveCompletion: { completion in
                cancellable?.cancel()
                cancellable = nil
                switch completion {
                case .failure(let error):
                    promise(.failure(error))
                case .finished:
                    fatalError()
                }
            },receiveValue: { products in
                cancellable?.cancel()
                cancellable = nil
                promise(.success(products))
                try? local.save(products: products)
            })

        }
    }

}
