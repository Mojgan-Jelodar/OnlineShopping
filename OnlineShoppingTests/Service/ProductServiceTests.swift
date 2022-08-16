//
//  ProductServiceTests.swift
//  ChocoTests
//
//  Created by Mozhgan on 9/27/21.
//

import XCTest
import Combine
@testable import OnlineShopping

class ProductServiceTests : XCTestCase {

    var describe  = Set<AnyCancellable>()
    override func setUp() {
        super.setUp()
    }
    override func tearDown() {
        super.tearDown()
    }
    func testGetProductsServiceShouldBeRtuenProducts() {
        let expectation = XCTestExpectation(description: "Fetch products")
        let service = MockProductService()
        service.getAllProducts().sink(receiveCompletion: { completion in
            switch completion {
            case .failure(let error):
            XCTFail(error.localizedDescription)
            expectation.fulfill()
            case .finished:
            break
            }
        }, receiveValue: { response in
            XCTAssertNotNil(response, "No product is exsist.")
        }).store(in: &describe)

    }
}
