//
//  LoginInteractor.swift
//  Choco
//
//  Created by Mozhgan on 9/27/21.
//

import Foundation
import Combine

protocol LoginBusinessLogic {
    func loginPressed(username : String,password : String)
}
extension Login {
    final class Interactor : LoginBusinessLogic {
        let worker : SessionNetworkManager?
        let presenter : LoginPresentationLogic?
        required init(worker : SessionNetworkManager?,
                      presenter : LoginPresentationLogic?) {
            self.worker = worker
            self.presenter = presenter
        }
        var subscriber = Set<AnyCancellable>()
        func loginPressed(username: String, password: String) {
            if username.isEmpty {
                presenter?.loginFailedBy(error: ChocoError(reason: R.string.shared.requiedFieldsError(R.string.login.loginUsernameTitle())))
            } else if !ValidationManager.validateEmail(email: username) {
                presenter?.loginFailedBy(error: ChocoError(reason: R.string.shared.invalidEmailError()))
            } else if password.isEmpty {
                presenter?.loginFailedBy(error: ChocoError(reason: R.string.shared.requiedFieldsError(R.string.login.loginPasswordTitle())))
            } else {
                self.performLogin(username: username, password: password)
            }
        }

        func performLogin(username: String, password: String) {
            worker?.login(param: LoginBussinessModel.Request(email: username, password: password))
                .sink(receiveCompletion: {[weak self] completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        self?.presenter?.loginFailedBy(error: error)
                    }
                }, receiveValue: { [weak self] reponse in
                    UserCredintial.shared.accessToken = reponse.token
                    self?.presenter?.loggedIn()
                }).store(in: &subscriber)
        }
    }
}
