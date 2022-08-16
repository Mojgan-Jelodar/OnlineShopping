//
//  UIView.swift
//  Choco
//
//  Created by Mozhgan on 9/28/21.
//

import UIKit
import SnapKit
extension UIView {
    func lock() {
        if viewWithTag(9877) == nil {
            let lockView = UIView()
            lockView.backgroundColor = UIColor(white: 0.0, alpha: 0.2)
            lockView.tag = 9877
            lockView.alpha = 0.0
            addSubview(lockView)
            let activity = UIActivityIndicatorView(style: .large)
            activity.hidesWhenStopped = true
            lockView.addSubview(activity)
            activity.startAnimating()
            lockView.snp.makeConstraints { maker in
                maker.edges.equalToSuperview()
            }
            activity.snp.makeConstraints { maker in
                maker.center.equalToSuperview()
            }
            UIView.animate(withDuration: 0.2) {
                lockView.alpha = 1.0
            }
        }
    }

    func unlock() {
        if let lockView = viewWithTag(9877) {
            UIView.animate(withDuration: 0.2, animations: ({
                lockView.alpha = 0.0
            }), completion: { _ in
                lockView.removeFromSuperview()
            })
        }
    }
}
