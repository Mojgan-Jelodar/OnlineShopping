//
//  MockProductService.swift
//  ChocoTests
//
//  Created by Mozhgan on 10/1/21.
//
import Foundation
import Combine
@testable import OnlineShopping

struct MockProductService : ProductNetworkManager {
    func getAllProducts() -> AnyPublisher<ProductNetworkModel.ProductsResponse, Error> {
        CombineMoyaNetworkExecuter
            .shared.makeNetworkRequestForAPIService(service: ProductApi.getProducts,
                                                    networkProvider: sharedMockNetworkProvider)
            .decode(type: ProductNetworkModel.ProductsResponse.self, decoder: newJSONDecoder())
            .eraseToAnyPublisher()
    }
}
