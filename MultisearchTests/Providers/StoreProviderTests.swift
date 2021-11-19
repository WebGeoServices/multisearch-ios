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
        XCTAssertEqual(5, responseResult?.count, "Matching record counts")
        XCTAssertEqual("Frys Store #674", responseResult?.first?.description, "Matching Details of result")
    }

    func testDetail() throws {
        // given
        let testObject = StoreProvider( storeProvider)
        var responseError: APIClient.Error?
        var responseResult: DetailsResponseItem?

        let promise = expectation(description: "Should return result ")
        // when
        testObject.details("22018_214825") { (result, error) in
            responseResult = result
            responseError = error
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)

        // then
        XCTAssertNil(responseError)
        XCTAssertEqual("13982 W. Waddell null null", responseResult?.formattedAddress)
        XCTAssertEqual(.store, responseResult?.api)
    }
}
