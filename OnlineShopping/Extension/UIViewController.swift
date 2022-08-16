//
//  UIViewController.swift
//  Choco
//
//  Created by Mozhgan on 9/28/21.
//

import Foundation
import UIKit
extension  UIViewController {
    func showAlert(withTitle title: String,
                   withMessage message:String,
                   buttonTitle:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: buttonTitle, style: .default)
        alert.addAction(ok)
        DispatchQueue.main.async(execute: {
            self.present(alert, animated: true)
        })
    }
    class var window: UIWindow? {
      guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
          let delegate = windowScene.delegate as? SceneDelegate, let window = delegate.window else { return nil }
             return window
   }
}
