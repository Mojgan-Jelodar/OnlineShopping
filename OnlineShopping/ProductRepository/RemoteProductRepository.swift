//
//  RemoteProductRepository.swift
//  Choco
//
//  Created by Mozhgan on 9/27/21.
//

import Foundation
import Combine

protocol RemoteProductRepositoryProtocol : ProductRepository {
    var networkManager : ProductNetworkManager { get set}

}
struct RemoteProductRepository : RemoteProductRepositoryProtocol {
    var networkManager: ProductNetworkManager

    func fetchProducts() -> Future<ProductNetworkModel.ProductsResponse, Error> {
        networkManager.getAllProducts().asFuture()
    }
}
