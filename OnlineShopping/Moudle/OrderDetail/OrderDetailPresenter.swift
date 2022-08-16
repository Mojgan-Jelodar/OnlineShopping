//
//  OrderDetailPresenter.swift
//  Choco
//
//  Created by Mozhgan on 10/12/21.
//

import Foundation
protocol OrderDetailPresentationLogic {
    func fetched(order : ProductOrder)
}
protocol OrderDetailDisplayLogic : AnyObject {
    func show(viewModel : OrderDetail.ViewModel)
}

extension OrderDetail {
    class Presenter : OrderDetailPresentationLogic {
        weak var viewController : OrderDetailDisplayLogic?
        init(viewController : OrderDetailDisplayLogic) {
            self.viewController = viewController
        }
        func fetched(order: ProductOrder) {
            let viewModel = OrderDetail.ViewModel(name: order.product.name ?? "-",
                                                  price: order.product.price.formmatedPrice(),
                                                  photo: order.product.photo ?? "",
                                                  description: order.product.text ?? "",
                                                  quantity:order.quantity,
                                                  totalPrice: order.price.formmatedPrice())
            viewController?.show(viewModel: viewModel)
        }
    }
}
