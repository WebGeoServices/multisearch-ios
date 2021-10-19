//
//  LocalitiesProviderTests.swift
//  MultisearchTests
//
//  Created by apple on 10/05/21.
//

import XCTest
@testable import Multisearch
class LocalitiesProviderTests: XCTestCase {
    var localitiesProvider: ProviderConfig!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        localitiesProvider = ProviderConfig(searchType: .localities,
                                                                key: FakeTestData.woosmapKey,
                                                                fallbackBreakpoint: 0.4,
                                                                param: ConfigParam(components: Components(country: ["fr"]),
                                                                                   types: ["locality", "postal_code"],
                                                                                   language: "fr"))
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSearch() throws {
        // given
        let testObject = LocalitiesProvider( localitiesProvider)

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
        XCTAssertNil(responseError)
        XCTAssertEqual(5, responseResult?.count, "Matching Record count")
        XCTAssertEqual("Paris, France", responseResult?.first?.description, "Matching Details of result")
        responseResult?.forEach({ (response) in
            XCTAssertNotNil(response.matchedSubstrings)
        })

    }

    func testDetail() throws {
        // given
        let testObject = LocalitiesProvider( localitiesProvider)
        var responseError: APIClient.Error?
        var responseResult: DetailsResponseItem?

        let promise = expectation(description: "Should return result ")
        // when
        testObject.details("tZJ25ZbtBPSiSxYUyQPJdYapLzM=") { (result, error) in
            responseResult = result
            responseError = error
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)

        // then
        XCTAssertNil(responseError)
        XCTAssertEqual("Papeete", responseResult?.formattedAddress)
    }
}
