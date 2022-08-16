//
//  ViewModel.swift
//  Choco
//
//  Created by Mozhgan on 9/28/21.
//

import Foundation
import Combine
extension OrderList {
    struct OrdersViewModel {
        let orders : [ProductOrderViewModel]

    }
    struct ProductViewModel {
        let name : String?
        let photo : String?
        let price : String?
        let id : String?
    }
    final class ProductOrderViewModel {
        let product : ProductViewModel
        let quantity : Int
        let totalPrice : String
        required init(product : ProductViewModel,quantity : Int = 0,totalPrice : String) {
            self.product = product
            self.quantity = quantity
            self.totalPrice = totalPrice
        }
    }

    struct ErrorViewModel {
        let message : String?
    }
}
