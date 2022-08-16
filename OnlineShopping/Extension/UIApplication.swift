//
//  File.swift
//  Blu
//
//  Created by Mozhgan on 9/18/21.
//

import Foundation
import UIKit
extension UIApplication {
    public class func topViewController(base: UIViewController? = nil) -> UIViewController? {
        let rootViewController = base ?? UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController
        if let nav = rootViewController as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }

        if let tab = rootViewController as? UITabBarController {
            let moreNavigationController = tab.moreNavigationController

            if let top = moreNavigationController.topViewController, top.view.window != nil {
                return topViewController(base: top)
            } else if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }

        if let presented = rootViewController?.presentedViewController {
            return topViewController(base: presented)
        }

        return base
    }
}
