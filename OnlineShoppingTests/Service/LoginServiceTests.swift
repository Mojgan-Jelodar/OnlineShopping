//
//  LoginServiceTests.swift
//  ChocoTests
//
//  Created by Mozhgan on 9/27/21.
//

import XCTest
import Combine
@testable import OnlineShopping

class LoginServiceTests : XCTestCase {

    var describe  = Set<AnyCancellable>()
    override func setUp() {
        super.setUp()
    }
    override func tearDown() {
        super.tearDown()
    }
    func testLoginServiceShouldBeRtuenUser() {
        let expectation = XCTestExpectation(description: "Login")
        let service = MockLoginService()
        service.login(param: Seeds.user).sink(receiveCompletion: { completion in
            switch completion {
            case .failure(let error):
            XCTFail(error.localizedDescription)
            expectation.fulfill()
            case .finished:
            break
            }
        }, receiveValue: { response in
            XCTAssertNotNil(response, "No user is exsist.")
        }).store(in: &describe)

    }
}
