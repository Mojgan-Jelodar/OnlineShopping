//
//  ProductDetailBuilder.swift
//  Choco
//
//  Created by Mozhgan on 9/28/21.
//

import Foundation
extension OrderDetail {
    struct Builder : SceneBuilder {
        typealias Output = OrderDetailVC
        typealias Input = ProductOrder
        static func build(with: ProductOrder) -> OrderDetailVC {
            let vc = OrderDetailVC()
            let interactor = OrderDetail.Interactor(order: with, presenter: OrderDetail.Presenter(viewController: vc))
            vc.interactor = interactor
            return vc
        }
    }
}
