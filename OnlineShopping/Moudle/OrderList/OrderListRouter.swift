//
//  ProductListRouter.swift
//  Choco
//
//  Created by Mozhgan on 9/28/21.
//

import Foundation
import UIKit
protocol OrderListRouterLogic {
    func naviagteToDetail(index : Int)
    func logout()
}
protocol OrderListRouterDataPassing {
    var dataStore : OrderListDataSource? { get }
}

extension OrderList {
    final class Router : OrderListRouterLogic,OrderListRouterDataPassing {
        var dataStore: OrderListDataSource?
        weak var viewController : UIViewController?
        init(viewcontroller : UIViewController) {
            self.viewController = viewcontroller
        }
        func naviagteToDetail(index: Int) {
            if let products = dataStore?.products {
                let product = products[index]
                let quantity = dataStore?.orders.filter({$0.id == product.id}).first?.quantity ?? 0
                let vc = OrderDetail.Builder.build(with: ProductOrder(product: product, quantity: quantity))
                self.viewController?.navigationController?.present(vc, animated: true, completion: nil)
            }
        }

       func logout() {
            UserLocalStorage.shared.reset()
            viewController?.view.window?.rootViewController = Login.Builder.build()
        }
    }
}
