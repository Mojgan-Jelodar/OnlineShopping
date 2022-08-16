//
//  OrderDetailInteractor.swift
//  Choco
//
//  Created by Mozhgan on 10/12/21.
//

import Foundation
import Combine
protocol OrderDetailBusinessLogic {
    func updateOrder(value: Int)
    func fecthOrder()

}
protocol OrderDetailDataStore {
    var order : ProductOrder! { get set}
}

extension OrderDetail {
    class Interactor : OrderDetailBusinessLogic,OrderDetailDataStore {
        private var cancellable = Set<AnyCancellable>()
        var order: ProductOrder! {
            didSet {
                self.presenter?.fetched(order: order)
            }
        }
        var presenter : OrderDetailPresentationLogic?
        init(order : ProductOrder,
             presenter : OrderDetailPresentationLogic?) {
            self.presenter = presenter
            self.order = order
            shoppingCartReceiver.$orders
                .sink(receiveValue: {orders in
                    guard let updatedOrder =  orders.first(where: {$0.id == order.id}) else {
                        self.order = ProductOrder(product: self.order.product,quantity: 0)
                        return
                    }
                    self.order = updatedOrder
            }).store(in: &cancellable)
        }
        private func insert() {
            ShoppingCart.shared.insert(product: order.product)
        }
        private func incrementProduct() {
            ShoppingCart.shared.incrementProduct(with: order.product.id!)
        }
        private func decrementProduct() {
            ShoppingCart.shared.decrementProduct(with: order.product.id!)
        }
    }
}
extension OrderDetail.Interactor {
    func fecthOrder() {
        self.presenter?.fetched(order: order)
    }
    func updateOrder(value: Int) {
        if order.quantity == 0 {
            self.insert()
        } else if order.quantity > value {
            self.decrementProduct()
        } else {
            self.incrementProduct()
        }
    }
}
