//
//  ProductListBuilder.swift
//  Choco
//
//  Created by Mozhgan on 9/28/21.
//

import Foundation
import UIKit
extension OrderList {
    struct Builder : SceneBuilder {
        typealias Input = Void
        typealias Output = OrderListVC
        static func build(with: Void) -> OrderListVC {
            let vc = OrderListVC()
            let inteactor = OrderList.Interactor(productWorker: ProductListWorker(local:LocalProductRepository(),
                                                                                  network: RemoteProductRepository(networkManager: MoyaProductManager())),
                                                 presenter: OrderList.Presenter(viewController: vc))
            let router = OrderList.Router(viewcontroller: vc)
            router.dataStore = inteactor
            vc.interactor = inteactor
            vc.router = router
            return vc

        }
    }
}
