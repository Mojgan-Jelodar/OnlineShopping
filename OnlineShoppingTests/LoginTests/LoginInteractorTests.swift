//
//  LoginInteractorTests.swift
//  ChocoTests
//
//  Created by Mozhgan on 9/30/21.
//

import Foundation
import XCTest
import Combine

@testable import OnlineShopping

class LoginInteractorTests : XCTestCase {
    override func setUp() {
        super.setUp()
    }
    override func tearDown() {
        super.setUp()
    }
    func testShouldAskLoginByValidUser() {
        let presenter = LoginPresenterSpy()
        let worker = MockLoginService()
        let interactor = LoginInteractorSpy(worker: worker,
                                            presenter: presenter)
        interactor.loginPressed(username: Seeds.user.email,
                                password: Seeds.user.password)
        XCTAssertTrue(presenter.userIsLoggedIn)
    }
    func testShouldAskLoginByInvalideUser() {
        let presenter = LoginPresenterSpy()
        let worker = MockLoginService()
        let interactor = LoginInteractorSpy(worker: worker,
                                            presenter: presenter)
        interactor.loginPressed(username: "Seeds.user.email" ,
                                password: Seeds.user.password )
        XCTAssertTrue(presenter.errorWasPresented)
    }
}

class LoginInteractorSpy: LoginBusinessLogic {
    let worker : SessionNetworkManager?
    let presenter : LoginPresentationLogic?
    private var subscriber = Set<AnyCancellable>()
    required init(worker : SessionNetworkManager?,
                  presenter : LoginPresentationLogic?) {
        self.worker = worker
        self.presenter = presenter
    }
    enum LoginWorkerSpyError: Error {

        case generic
    }
    func loginPressed(username: String, password: String) {
        guard ValidationManager.validateEmail(email: username) else {
            self.presenter?.loginFailedBy(error: LoginWorkerSpyError.generic)
            return
        }
        guard !password.isEmpty else {
            self.presenter?.loginFailedBy(error: LoginWorkerSpyError.generic)
            return
        }
        callApi(username: username, password: password)
    }
    private func callApi(username: String, password: String) {
        let expectation = XCTestExpectation(description: "Login")
        worker?.login(param: LoginBussinessModel.Request(email: username,
                                                         password: password))
            .sink(receiveCompletion: {[weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.presenter?.loginFailedBy(error: error)
                    expectation.fulfill()
                }
            }, receiveValue: { [weak self] _ in
                self?.presenter?.loggedIn()
                expectation.fulfill()
            }).store(in: &subscriber)
       _ =  XCTWaiter.wait(for: [expectation], timeout: 10.0)
    }
}

class LoginPresenterSpy: LoginPresentationLogic {
    var userIsLoggedIn = false
    var errorWasPresented = false
    func loggedIn() {
        userIsLoggedIn = true
    }
    func loginFailedBy(error: Error) {
        errorWasPresented = true
    }
}
