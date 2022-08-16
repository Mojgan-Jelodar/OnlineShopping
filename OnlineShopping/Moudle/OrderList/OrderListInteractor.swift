//
//  ProductInteractor.swift
//  Choco
//
//  Created by Mozhgan on 9/28/21.
//

import Foundation
import Combine
public protocol OrderListBusinessLogic {
    func fetchProducts()
    func updateOrder(index : Int,value : Int)
}
public protocol OrderListDataSource {
    var orders : [ProductOrder] { get set}
    var products : [Product] { get set}
}

extension OrderList {
    final class Interactor : OrderListDataSource,OrderListBusinessLogic {
        var orders: [ProductOrder] = [] {
            didSet {
                self.presenter?.fetched(products: products, orders: self.orders)
            }
        }
        var products : [Product] = [] {
            didSet {
                ShoppingCart.shared.load()
                self.presenter?.fetched(products: products, orders: self.orders)
            }
        }
        var productWorker : ProductRepository?
        let presenter : OrdersPresentationLogic?
        private var cancellable = Set<AnyCancellable>()

        init(productWorker : ProductRepository,
             presenter :OrdersPresentationLogic) {
            self.productWorker = productWorker
            self.presenter = presenter
            shoppingCartReceiver.$orders.filter({$0.count > 0}).assign(to: \.orders, on: self).store(in: &cancellable)
        }
    }
}
// MARK: Basket
extension OrderList.Interactor {
    private func insert(index: Int) {
        let product = self.products[index]
        ShoppingCart.shared.insert(product: product)
    }

    private func incrementProduct(index: Int) {
        guard let id = self.products[index].id else {
            return
        }
        ShoppingCart.shared.incrementProduct(with: id)
    }

    private func decrementProduct(index: Int) {
        guard let id = self.products[index].id else {
            return
        }
        ShoppingCart.shared.decrementProduct(with: id)
    }
}
// MARK: Local Storage
extension OrderList.Interactor {
    func fetchProducts() {
        productWorker?.fetchProducts().sink(receiveCompletion: {[weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.presenter?.fetchedBy(error: error)
                }
            },receiveValue: { [weak self] products in
                self?.products = products

            }).store(in: &cancellable)
    }

    func updateOrder(index: Int, value: Int) {
        let product = self.products[index]
        if let order = self.orders.filter({$0.id == product.id}).first {
            if order.quantity>value {
                self.decrementProduct(index: index)
            } else {
                self.incrementProduct(index: index)
            }
        } else {
            self.insert(index: index)
        }
    }

}
