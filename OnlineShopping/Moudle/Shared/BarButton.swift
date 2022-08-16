//
//  MainVC.swift
//  Choco
//
//  Created by Mozhgan on 10/1/21.
//

import UIKit

enum  BarButtonItemType:Int {
    case logout
    case back
    func image() -> UIImage? {
        switch self {
        case .logout:
            return R.image.logout()
        case .back:
            return R.image.back()
        }
    }
}

extension UIBarButtonItem {
    convenience init(type:BarButtonItemType, target:Any, action:Selector) {
        let button = UIButton(frame: CGRect(origin: CGPoint.zero, size: LayoutContants.Shared.barButtonSize))
        button.setImage(type.image(), for: UIControl.State.normal)
        button.addTarget(target, action: action, for: .touchUpInside)
        let vw = UIView(frame: CGRect(origin: CGPoint.zero, size: LayoutContants.Shared.barButtonSize))
        vw.addSubview(button)
        self.init(customView:vw)
    }
}

protocol BarButtonItems {
}

extension BarButtonItems where Self:NSObject {
    func barButton(type:BarButtonItemType, action:Selector) -> UIBarButtonItem {
        return UIBarButtonItem(type: type, target: self, action: action)
    }
}
extension UIViewController : BarButtonItems {
}
