//
//  MoyaSessionManager.swift
//  Choco
//
//  Created by Mozhgan on 9/27/21.
//

import Foundation
import Combine
struct MoyaSessionManager : SessionNetworkManager {
    func login(param: LoginBussinessModel.Request) -> AnyPublisher<LoginNetworkModel.Response, Error> {
        CombineMoyaNetworkExecuter
            .shared.makeNetworkRequestForAPIService(service:
                                                        SessionApi.login(params: param.wsModel()),
                                                    networkProvider:sharedNetworkProvider)
            .decode(type: LoginNetworkModel.Response.self, decoder: newJSONDecoder())
            .eraseToAnyPublisher()
    }
}
