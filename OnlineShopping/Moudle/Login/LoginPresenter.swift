//
//  LoginPresenter.swift
//  Choco
//
//  Created by Mozhgan on 9/27/21.
//

import Foundation
protocol LoginPresentationLogic {
    func loggedIn()
    func loginFailedBy(error : Error)
}
protocol LoginDisplayLogic : AnyObject {
    func show(viewModel : Login.ViewModel)
    func loggedIn()
}

extension Login {
    final class Presenter : LoginPresentationLogic {
        weak var viewcontroller : LoginDisplayLogic?

        required init(viewcontroller : LoginDisplayLogic) {
            self.viewcontroller = viewcontroller
        }
        func loggedIn() {
            viewcontroller?.loggedIn()
        }
        func loginFailedBy(error: Error) {
            viewcontroller?.show(viewModel: Login.ViewModel(message: error.localizedDescription))
        }
    }
}
