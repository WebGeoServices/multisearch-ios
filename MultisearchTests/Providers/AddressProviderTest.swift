//
//  AddressProviderTest.swift
//  MultisearchTests
//
//  Created by apple on 10/05/21.
//

import XCTest
@testable import Multisearch
class AddressProviderTest: XCTestCase {
    var addressProvider: ProviderConfig!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        addressProvider = ProviderConfig(searchType: .address,
                                              key: FakeTestData.woosmapKey,
                                              fallbackBreakpoint: 0.8,
                                              minInputLength: 1,
                                              param: ConfigParam(components: Components(country: ["FR"]),
                                                language: "fr"))
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSearch() throws {
        // given
        let testObject = AddressProvider( addressProvider)

        var responseError: APIClient.Error?
        var responseResult: [AutocompleteResponseItem]?
        let promise = expectation(description: "Should return result ")
        // when
        testObject.search("paris") { (result, error) in
            responseResult = result
            responseError = error
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)

        // then
        XCTAssertNil(responseError, "error")
        XCTAssertEqual(1, responseResult?.count, "Matching record counts")
        XCTAssertEqual("Paris, Île-de-France, France", responseResult?.first?.description, "Matching Details of result")
        responseResult?.forEach({ (response) in
            XCTAssertNotNil(response.matchedSubstrings)
        })

    }

    func testDetail() throws {
        // given
        let testObject = AddressProvider( addressProvider)
        var responseError: APIClient.Error?
        var responseResult: DetailsResponseItem?

        let promise = expectation(description: "Should return result ")
        // when
        testObject.details("UGFyaXMsIMOObGUtZGUtRnJhbmNlLCBGcmFuY2U=") { (result, error) in
            responseResult = result
            responseError = error
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)

        // then
        XCTAssertNil(responseError)
        XCTAssertEqual("Paris, Île-de-France, France", responseResult?.formattedAddress)
    }

}
