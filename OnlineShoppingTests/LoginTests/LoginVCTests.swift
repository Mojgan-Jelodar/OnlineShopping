//
//  LoginVCTests.swift
//  ChocoTests
//
//  Created by Mozhgan on 9/30/21.
//

@testable import OnlineShopping
import XCTest

class LoginVCTests : XCTestCase {
    private var window: UIWindow!
    override func tearDown() {
        super.tearDown()
        window = nil
    }
    override func setUp() {
        super.setUp()
        window = UIWindow()
    }
    func testInitShouldSetViewControllerRouter() {
        let vc = Login.Builder.build()
        XCTAssertNotNil(vc.router)
    }
    func testInitShouldSetViewControllerInteractor() {
        let vc = Login.Builder.build()
        XCTAssertNotNil(vc.interactor)
    }
    func testInitShouldSetInteractorOutput() {
        let vc = Login.Builder.build()
        if let interactor = vc.interactor as? Login.Interactor {
            XCTAssertNotNil(interactor.presenter)
        } else {
            XCTFail("\(#file) : \(#line) - there is problem in InitShouldSetViewControllerInteractor")
        }
    }
    func testInitShouldSetPresenterOutput() {
        let vc = Login.Builder.build()
        if let interactor = vc.interactor as? Login.Interactor,
           let presenter = interactor.presenter as? Login.Presenter {
            XCTAssertNotNil(presenter.viewcontroller)
        } else {
            XCTFail("\(#file) : \(#line) - there is a problem in InittShouldSetPresenterOutput")
        }
    }
    func testViewDidLoadShouldSetupTitle() {
        let vc = Login.Builder.build()
        loadView(window: window, viewController: vc)
        XCTAssertEqual(vc.title, R.string.login.titlePage())
    }

    func testLoadViewShouldSetupHolderView() {
        let vc = Login.Builder.build()
        loadView(window: window, viewController: vc)
        let holderView = vc.holderView
        XCTAssertNotNil(holderView)
    }
    func testLoadViewShouldSetupEmailTextFiled() {
        let vc = Login.Builder.build()
        loadView(window: window, viewController: vc)
        let emailTextFiled = vc.emailTextFiled
        XCTAssertNotNil(emailTextFiled)
    }
    func testLoadViewShouldSetupPasswordTextFiled() {
        let vc = Login.Builder.build()
        loadView(window: window, viewController: vc)
        let passwordTextField = vc.passwordTextField
        XCTAssertNotNil(passwordTextField)
    }
    func testLoadViewShouldSetupLoginButton() {
        let vc = Login.Builder.build()
        loadView(window: window, viewController: vc)
        let loginButton = vc.loginButton
        XCTAssertNotNil(loginButton)
    }
    func testLoginAction() {
        let vc = LoginVC()
        let inteactor = LoginInteractorProtocolSpy()
        vc.interactor = inteactor
        vc.interactor?.loginPressed(username: Seeds.user.email,
                                                  password: Seeds.user.password)
        XCTAssertEqual(inteactor.loginIsTapped,true)
    }
    func testShouldBeRoutingToDashboard() {
        let vc = LoginVC()
        let router = LoginRouterSpy()
        vc.router = router
        router.naviagteToDashboard()
        XCTAssertTrue(router.userIsLoggedIn)
    }
}

private class LoginInteractorProtocolSpy : LoginBusinessLogic {
    private(set) var loginIsTapped = false
    func loginPressed(username: String, password: String) {
        loginIsTapped = true
    }
}

private class LoginRouterSpy : LoginRouterLogic {
    var userIsLoggedIn = false
    func naviagteToDashboard() {
        userIsLoggedIn = true
    }
}
