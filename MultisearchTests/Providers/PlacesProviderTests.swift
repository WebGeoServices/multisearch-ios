//
//  PlacesProviderTests.swift
//  MultisearchTests
//
//  Created by apple on 10/05/21.
//

import XCTest
@testable import Multisearch

class PlacesProviderTests: XCTestCase {

    var placesProvider: ProviderConfig!
    var placesProviderInvalid: ProviderConfig!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        placesProvider = ProviderConfig(searchType: .places,
                                             key: FakeTestData.placesKey,
                                             fallbackBreakpoint: 0.7,
                                             minInputLength: 1,
                                             param: ConfigParam.init(
                                                components: Components(country: ["FR"])))
        placesProviderInvalid = ProviderConfig(searchType: .places,
                                             key: "AIzaSyCvYYEPtdBfvB3XM78ufDjnONesO6SBOwo",
                                             fallbackBreakpoint: 0.7,
                                             minInputLength: 1,
                                             param: ConfigParam.init(
                                                components: Components(country: ["FR"])))
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSearch() throws {
        // given
        let testObject = PlacesProvider(placesProvider)

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
        XCTAssertEqual(5, responseResult?.count, "Matchng record counts")
        XCTAssertEqual("Paris, France", responseResult?.first?.description, "Matching Details of result")
        responseResult?.forEach({ (response) in
            XCTAssertNotNil(response.matchedSubstrings)
        })

    }

    func testSearch_invalidKey() throws {
        // given
        let testObject = PlacesProvider(placesProviderInvalid)

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
        XCTAssertNotNil(responseError, "function should return errors")
        XCTAssertNil(responseResult, "function should not return result")

    }

    func testDetail() throws {
        // given
        let testObject = PlacesProvider( placesProvider)
        var responseError: APIClient.Error?
        var responseResult: DetailsResponseItem?

        let promise = expectation(description: "Should return result ")
        // when
        testObject.details("ChIJoyxn-LU39UcRcoI_eWJnhW0") { (result, error) in
            responseResult = result
            responseError = error
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)

        // then
        XCTAssertNil(responseError, "function should return errors")
        XCTAssertEqual("Combe Lézard, 26330 Tersanne, France", responseResult?.formattedAddress, "Address not matctch with expected")
    }

    func testDetail_InvalidKey() throws {
        // given
        let testObject = PlacesProvider( placesProviderInvalid)
        var responseError: APIClient.Error?
        var responseResult: DetailsResponseItem?

        let promise = expectation(description: "Should return result ")
        // when
        testObject.details("ChIJoyxn-LU39UcRcoI_eWJnhW0") { (result, error) in
            responseResult = result
            responseError = error
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)

        // then
        XCTAssertNotNil(responseError, "function should return errors")
        XCTAssertNil(responseResult, "function should not return result")
    }

}
