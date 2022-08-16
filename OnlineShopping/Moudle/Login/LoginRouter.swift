//
//  LoginRouter.swift
//  Choco
//
//  Created by Mozhgan on 9/27/21.
//

import Foundation
import UIKit
protocol LoginRouterLogic {
    func naviagteToDashboard()
}
extension Login {
    class Router : LoginRouterLogic {
        weak var viewcontroller : UIViewController?
        required init(viewcontroller : UIViewController) {
            self.viewcontroller = viewcontroller
        }
        func naviagteToDashboard() {
            let vc = OrderList.Builder.build()
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .coverVertical
            viewcontroller?.view.window?.rootViewController = UINavigationController(rootViewController: vc)
        }
    }
}
