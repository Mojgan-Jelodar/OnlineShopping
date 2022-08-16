//
//  ReloginPublisher.swift
//  Blu
//
//  Created by jelodar on 6/16/1400 AP.
//

import Foundation
import Combine
import Moya

extension MoyaProvider {
    internal final class MoyaPublisher: Publisher {
        typealias Failure = MoyaError
        typealias Output = Result<Response, Error>
        let target : Target
        let networkProvider : MoyaProvider
        let callbackQueue: DispatchQueue?
        let progressBlock: ProgressBlock?

        init(target : Target,
             networkProvider :MoyaProvider,
             callbackQueue: DispatchQueue? = nil,
             progressBlock : ProgressBlock? = nil) {
            self.target = target
            self.networkProvider = networkProvider
            self.callbackQueue = callbackQueue
            self.progressBlock = progressBlock
        }

        func receive<S>(subscriber: S) where S : Subscriber, MoyaError == S.Failure, Output == S.Input {
            let subscription = MoyaSubscription(target: target,
                                                networkProvider: networkProvider,
                                                callbackQueue: callbackQueue,
                                                progressBlock: progressBlock,
                                                subscriber: subscriber)
            subscriber.receive(subscription: subscription)
        }

    }

    func requestPublisher(_ target: Target, callbackQueue: DispatchQueue? = nil) -> MoyaPublisher {
        return MoyaPublisher(target: target, networkProvider: self,callbackQueue: callbackQueue)
    }

}

extension MoyaProvider.MoyaPublisher {
    private final class MoyaSubscription<Output, S : Subscriber>: Subscription
    where S.Input == Output, S.Failure == Failure {

        private var subscriber: S?
        let target : Target
        let networkProvider : MoyaProvider
        let callbackQueue: DispatchQueue?
        let progressBlock: ProgressBlock?

        init(target : Target,
             networkProvider : MoyaProvider,
             callbackQueue: DispatchQueue? ,
             progressBlock : ProgressBlock? ,
             subscriber: S) {
          self.subscriber = subscriber
          self.target = target
          self.networkProvider = networkProvider
          self.callbackQueue = callbackQueue
          self.progressBlock = progressBlock
        }

        func request(_ demand: Subscribers.Demand) {
            if demand > 0 {
                networkProvider.request(target, callbackQueue: callbackQueue, progress: progressBlock) { [weak self] result  in
                    defer {
                        self?.cancel()
                    }
                    switch result {
                    case .success(let response) :
                        if case 200 ..< 400 = response.statusCode {
                            // swiftlint:disable force_cast
                            _ = self?.subscriber?.receive(Result<Response,Error>.success(response) as! Output)
                            // swiftlint:enable force_cast
                            self?.subscriber?.receive(completion: .finished)
                        } else {

                            self?.subscriber?.receive(completion: .failure(MoyaError.statusCode(response)))
                        }
                    case .failure(let error) :
                    self?.subscriber?.receive(completion: .failure(error))

                    }
                }
            }
        }
        func cancel() {
            subscriber = nil
        }
    }
}

extension Response {
    public func filterStatusCodes(failureCodes: [Int], in range: ClosedRange<Int>) throws -> Response {
        guard !failureCodes.contains(statusCode) && range.contains(statusCode) else {
            throw MoyaError.statusCode(self)
        }
        return self
    }
}
