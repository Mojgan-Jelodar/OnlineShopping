//
//  Publisher.swift
//  Choco
//
//  Created by Mozhgan on 9/27/21.
//

import Combine

extension Publisher {
    func asFuture() -> Future<Output, Failure> {
        return Future {promise in
            var cancellable: AnyCancellable?
            cancellable = self.sink(
                receiveCompletion: {
                    cancellable?.cancel()
                    cancellable = nil
                    switch $0 {
                    case .failure(let error):
                        promise(.failure(error))
                    case .finished:
                        // WHAT DO WE DO HERE???
                        fatalError()
                    }
            },
                receiveValue: {
                    cancellable?.cancel()
                    cancellable = nil
                    promise(.success($0))
            })
        }
    }
}

extension Publisher {
    @available(iOS 14.0, *)
    func retry<T: Scheduler>(
        _ retries: Int,
        delay: T.SchedulerTimeType.Stride,
        scheduler: T
    ) -> AnyPublisher<Output, Failure> {
        self.catch { _ in
            Just(())
                .delay(for: delay, scheduler: scheduler)
                .setFailureType(to: Never.self)
                .flatMap(maxPublishers: Subscribers.Demand.max(1)) { _ in self }
                .retry(retries > 0 ? retries - 1 : 0)
        }
        .eraseToAnyPublisher()
    }
}

extension Publishers {
    struct RetryIf<P: Publisher>: Publisher {
        typealias Output = P.Output
        typealias Failure = P.Failure

        let publisher: P
        let times: Int
        let condition: (P.Failure) -> Bool

        func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
            guard times > 0 else { return publisher.receive(subscriber: subscriber) }

            publisher.catch { (error: P.Failure) -> AnyPublisher<Output, Failure> in
                if condition(error) {
                    return RetryIf(publisher: publisher, times: times - 1, condition: condition).eraseToAnyPublisher()
                } else {
                    return Fail(error: error).eraseToAnyPublisher()
                }
            }.receive(subscriber: subscriber)
        }
    }
}

extension Publisher {
    func retry(times: Int, if condition: @escaping (Failure) -> Bool) -> Publishers.RetryIf<Self> {
        Publishers.RetryIf(publisher: self, times: times, condition: condition)
    }
}
