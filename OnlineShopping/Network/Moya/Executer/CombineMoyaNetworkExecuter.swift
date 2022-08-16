//
//  File.swift
//  Blu
//
//  Created by Mozhgan on 8/30/21.
//

import Foundation
import Moya
import Combine
import SwiftUI

struct CombineMoyaNetworkExecuter {
    static let shared = CombineMoyaNetworkExecuter()
    let authenticator = AppAuthenticator(loginView: AppReloginHandler())
    func makeNetworkRequestForAPIService(service: TargetType,
                                         networkProvider: MoyaProvider<MultiTarget>,
                                         callbackQueue : DispatchQueue = .main) -> AnyPublisher<Data, Error> {
        let tokenSubject =  authenticator.tokenSubject()
        return tokenSubject
            .setFailureType(to: Error.self)
            .flatMap(maxPublishers: Subscribers.Demand.max(1)) { _ in
                return networkProvider.requestPublisher(MultiTarget(service),callbackQueue: callbackQueue)
                .share()
                .catch { error -> AnyPublisher<Result<Response, Error>, Error> in
                let response : HTTPURLResponse? = error.response?.response
                let statusCode : HTTPStatusCode = (response?.status ?? .ok)
                switch statusCode {
                case .serviceUnavailable,.tooManyRequests :
                    return Fail(error: error)
                        .delay(for: 5, scheduler: callbackQueue)
                        .eraseToAnyPublisher()
                case .unauthorized :
                    authenticator.sessionIsExpired(using: tokenSubject)
                    return Empty().eraseToAnyPublisher()
                default:
                    let serverMessage = try? ServerMessage(data: error.response?.data ?? Data())
                    let serverError = (serverMessage != nil) ?
                                        MoyaError.underlying(ChocoError(reason: serverMessage!.message!), error.response) :
                                        error
                    return Just(Result.failure(serverError))
                          .setFailureType(to: Error.self)
                          .eraseToAnyPublisher()

                }
                }
                .tryMap({ result in
                return try result.get().data
            }).eraseToAnyPublisher()
            }.handleEvents( receiveCompletion: { completion in
                tokenSubject.send(completion: .finished)
            }, receiveCancel: {
                tokenSubject.send(completion: .finished)
            }).eraseToAnyPublisher()
    }
}
