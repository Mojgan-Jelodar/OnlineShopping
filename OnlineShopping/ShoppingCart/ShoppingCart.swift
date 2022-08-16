//
//  File.swift
//  Choco
//
//  Created by Mozhgan on 10/1/21.
//

import Foundation
import Combine
protocol ShoppingCartActions {
    func insert(product: Product)
    func incrementProduct(with id: String)
    func decrementProduct(with id: String)
    func clear()
    func load()
}
final class ShoppingCart : ShoppingCartActions {

    static let shared = ShoppingCart()

    private let inMemoryShopingCart : InMemoryShopingCart = InMemoryShopingCart()
    let orders: AnyPublisher<[ProductOrder], Error>
    let repository : OrderRepository!
    private var cancellable = Set<AnyCancellable>()

    private lazy var inMemorySubject : PassthroughSubject<CartAction, Error> = {
        let tmp = PassthroughSubject<CartAction, Error>()
        tmp.receive(subscriber: inMemoryShopingCart.input)
        return tmp
    }()

    internal required init(repository : OrderRepository = LocalOrderRepository(storage: defaultRealmStorage)) {
        self.repository = repository
        self.orders = inMemoryShopingCart.orders
        binding()
    }
    private func binding() {
        self.orders.sink(receiveCompletion: { _ in

        },receiveValue: { orders in
            shoppingCartSender.orders = orders
            NotificationCenter.default.post(name: ShoppingCartNotificationSender.shoppingCartNotification, object: shoppingCartSender)
        }).store(in: &cancellable)
    }

}

extension ShoppingCart {
    func load() {
        repository.fetchOrders().sink( receiveCompletion: {  [weak self]  completion in
            switch completion {
            case .finished:
            break
            case .failure(let error):
            self?.inMemorySubject.send(completion: .failure(error))
            }

        } ,receiveValue: { [weak self] orders in
            orders.forEach({
                self?.inMemorySubject.send(.insert(product: $0.product, quantity: $0.quantity))
            })
        }).store(in: &cancellable)

    }
    func insert(product: Product) {
        repository.insert(product: product).sink(receiveCompletion: { [weak self] completion in
            switch completion {
            case .finished:
            break
            case .failure(let error):
            self?.inMemorySubject.send(completion: .failure(error))
            }
        },receiveValue: { _ in
            self.inMemorySubject.send(.insert(product: product, quantity: 1))
        }).store(in: &cancellable)

    }

    func incrementProduct(with id: String) {
        repository.incrementProduct(with: id).sink(receiveCompletion: { [weak self] completion in
            switch completion {
            case .finished:
            break
            case .failure(let error):
            self?.inMemorySubject.send(completion: .failure(error))
            }
        }, receiveValue: { [weak self] _ in
            self?.inMemorySubject.send(.incrementProduct(withId: id))
        }).store(in: &cancellable)

    }

    func decrementProduct(with id: String) {
        repository.decrementProduct(with: id).sink(receiveCompletion: { [weak self] completion in
            switch completion {
            case .finished:
            break
            case .failure(let error):
            self?.inMemorySubject.send(completion: .failure(error))
            }
        }, receiveValue: { [weak self] _ in
            self?.inMemorySubject.send(.decrementProduct(withId: id))
        }).store(in: &cancellable)
    }

    func clear() {
        repository.clearCache().sink(receiveCompletion: { [weak self]  completion in
            switch completion {
            case .finished:
            break
            case .failure(let error):
            self?.inMemorySubject.send(completion: .failure(error))
            }
        },receiveValue: {  [weak self] _ in
            self?.inMemorySubject.send(.clear)
        }).store(in: &cancellable)
    }
}

extension ShoppingCart {
    var numberOfProducts: AnyPublisher<Int, Error> {
        return orders.map(\.count).eraseToAnyPublisher()
    }
    var totalPrice: AnyPublisher<Double, Error> {
        return orders.map { $0.reduce(0) { (acc, order) -> Double in
                acc + order.price
            }
        }.eraseToAnyPublisher()
    }
}
extension ShoppingCart {
    func discountedTotalPrice(discountRate: Double = 0.1) -> AnyPublisher<Double, Error> {
        return totalPrice.map { $0 * (1.0 - discountRate) }.eraseToAnyPublisher()
    }
}
