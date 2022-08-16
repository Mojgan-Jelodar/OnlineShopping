//
//  MockLoginService.swift
//  ChocoTests
//
//  Created by Mozhgan on 10/1/21.
//

import Foundation
import Combine
@testable import OnlineShopping
struct MockLoginService : SessionNetworkManager {
    func login(param: LoginBussinessModel.Request) -> AnyPublisher<LoginNetworkModel.Response, Error> {
        CombineMoyaNetworkExecuter
            .shared
            .makeNetworkRequestForAPIService(service:
                                                        SessionApi.login(params: param.wsModel()),
                                                    networkProvider:sharedMockNetworkProvider)
            .decode(type: LoginNetworkModel.Response.self, decoder: newJSONDecoder())
            .eraseToAnyPublisher()
    }
}
