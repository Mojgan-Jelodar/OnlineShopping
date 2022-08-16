//
//  ProductPresenter.swift
//  Choco
//
//  Created by Mozhgan on 9/28/21.
//

import Foundation

protocol OrdersPresentationLogic {
    var viewController : OrdersDisplayLogic? {get set}
    func fetchedBy(error : Error)
    func fetched(products:[Product],orders : [ProductOrder])
}
protocol OrdersDisplayLogic : AnyObject {
    func show(viewModel : OrderList.OrdersViewModel)
    func show(viewModel : OrderList.ErrorViewModel)
}
extension OrderList {
    final class Presenter : OrdersPresentationLogic {

        weak var viewController : OrdersDisplayLogic?
        init(viewController : OrdersDisplayLogic) {
            self.viewController = viewController
        }

        func fetchedBy(error: Error) {
            viewController?.show(viewModel: OrderList.ErrorViewModel(message: error.localizedDescription))
        }

        func fetched(products: [Product], orders: [ProductOrder]) {

            let formattedOrders =  products.map { product -> ProductOrderViewModel in
                                                let order = orders.filter({$0.product.id == product.id}).first
                                                let quantity = order?.quantity ?? 0
                                                let totalPrice = order?.price ?? 0
                                                return ProductOrderViewModel(product: OrderList.ProductViewModel(name: product.name,
                                                                                                                 photo: product.photo,
                                                                                                                 price: product.price.formmatedPrice(),
                                                                                                                 id: product.id),
                                                                             quantity: quantity,
                                                                             totalPrice: totalPrice.formmatedPrice())
            }
            self.viewController?.show(viewModel: OrderList.OrdersViewModel(orders: formattedOrders))

        }

    }
}
