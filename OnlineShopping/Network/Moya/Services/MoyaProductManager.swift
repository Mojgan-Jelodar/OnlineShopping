//
//  MoyaProductManager.swift
//  Choco
//
//  Created by Mozhgan on 9/27/21.
//

import Foundation
import Combine
struct MoyaProductManager : ProductNetworkManager {
    func getAllProducts() -> AnyPublisher<ProductNetworkModel.ProductsResponse, Error> {
        CombineMoyaNetworkExecuter
            .shared.makeNetworkRequestForAPIService(service:
                                                        ProductApi.getProducts,
                                                    networkProvider:sharedNetworkProvider)
            .decode(type: ProductNetworkModel.ProductsResponse.self, decoder: newJSONDecoder())
            .eraseToAnyPublisher()
    }
}
