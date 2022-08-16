//
//  ProductSessionManager.swift
//  Choco
//
//  Created by Mozhgan on 9/27/21.
//

import Foundation
import Combine
protocol ProductNetworkManager {
    func getAllProducts() -> AnyPublisher<ProductNetworkModel.ProductsResponse,Error>
}
