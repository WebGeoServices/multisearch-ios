//
//  StoreProviderTests.swift
//  MultisearchTests
//
//  Created by apple on 10/05/21.
//

import XCTest
@testable import Multisearch
class StoreProviderTests: XCTestCase {
    var storeProvider: ProviderConfig!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        storeProvider = ProviderConfig(searchType: .store,
                                            key: FakeTestData.woosmapKey,
                                            fallbackBreakpoint: 0)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSearch() throws {
        // given
        let testObject = StoreProvider( storeProvider)
        var responseError: APIClient.Error?
        var responseResult: [AutocompleteResponseItem]?

        let promise = expectation(description: "Should return result ")
        // when
        testObject.search("store") { (result, error) in
            responseResult = result
            responseError = error
            promise.fulfill()
        }

        wait(for: [promise], timeout: 5)

        // then
        XCTAssertNil(responseError, "error")
        XCTAssertEqual(3, responseResult?.count, "Matching record counts")
        XCTAssertEqual("Woodburn Company Stores", responseResult?.first?.description, "Matching Details of result")
    }

    func testDetail() throws {
        // given
        let testObject = StoreProvider( storeProvider)
        var responseError: APIClient.Error?
        var responseResult: DetailsResponseItem?

        let promise = expectation(description: "Should return result ")
        // when
        testObject.details("8ad198b442c766280142c76629be00a5") { (result, error) in
            responseResult = result
            responseError = error
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)

        // then
        XCTAssertNil(responseError)
        XCTAssertEqual("1001   Arney Road    Woodburn  97071 Oregon", responseResult?.formattedAddress)
        XCTAssertEqual(.store, responseResult?.api)
    }
}
