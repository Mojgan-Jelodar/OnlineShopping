//
//  InMemoryShopingCart.swift
//  Choco
//
//  Created by jelodar on 7/18/1400 AP.
//

import Foundation
import Combine

final class InMemoryShopingCart {
    let orders: AnyPublisher<[ProductOrder], Error>
    let input: AnySubscriber<CartAction, Error>
    init() {
        let actionInput = PassthroughSubject<CartAction, Error>()
        self.orders = actionInput.scan([String:ProductOrder]()) { (currentOrders, action) -> [String:ProductOrder] in
            var newOrders = currentOrders
            switch action {
            case .insert(let product,let quantity):
                newOrders.updateValue(ProductOrder(product: product,quantity: quantity), forKey: product.id!)
            case .incrementProduct(withId: let productId):
                if let order = newOrders[productId] {
                    newOrders.updateValue(order.incremented, forKey: productId)
                }
            case .decrementProduct(withId: let productId):
                if let order = newOrders[productId] {
                    let decrementedOrder = order.decremented
                    if decrementedOrder.quantity == 0 {
                        newOrders.removeValue(forKey: productId)
                    } else {
                        newOrders.updateValue(decrementedOrder, forKey: productId)
                    }
                }
            case .clear:
                return [:]
            }
            return newOrders
        }
        .map(\.values)
        .map(Array.init)
        .eraseToAnyPublisher()
        self.input = AnySubscriber(actionInput)
    }
}
