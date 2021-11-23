//
//  UtilsTest.swift
//  MultisearchTests
//
//  Created by apple on 05/05/21.
//

import XCTest
import Foundation
@testable import Multisearch

class UtilsTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testformatQuery() throws {
        // given
        let localitiesProvider = ProviderConfig(searchType: .localities,
                                                key: "key 123",
                                                fallbackBreakpoint: 0.7,
                                                minInputLength: 1,
                                                param: ConfigParam(
                                                   components: Components(country: ["FR", "IN"]),
                                                   types: ["locality", "country", "postal_code"]))

        // when
        let test: [URLQueryItem] = Utils.formatQuery(apikey: "key 123", configParam: localitiesProvider.param)
        // then
        XCTAssertEqual(3, test.count, "No Matching record counts")
        XCTAssertEqual(test[0].value, "key 123", "Not matching value of key")
        XCTAssertEqual(test[1].value, "country:FR|country:IN", "Not matching value of key")
        XCTAssertEqual(test[2].value, "locality|country|postal_code", "Not matching value of key")
    }

    func testDebouncer() throws {
        // given
        let testObj = Debouncer(timeInterval: 2)
        let exp = expectation(description: "Test after 1 seconds")
        var resultcapture: [String] = []
        let expectedResult: [String] = ["call 2"]
        let promise = expectation(description: "Should return result ")
        // when
        testObj.renewInterval()
        testObj.handler = {
            resultcapture.append("call 1")
        }
        _ = XCTWaiter.wait(for: [exp], timeout: 1.0)
        testObj.renewInterval()
        testObj.handler = {
            resultcapture.append("call 2")
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
        // then
        XCTAssertEqual(1, resultcapture.count, "Not matching result count")
        XCTAssertEqual(expectedResult, resultcapture, "Both called get executed")
    }

    func testDebouncer_smallIntervel() throws {
        // given
        let testObj = Debouncer(timeInterval: 0.1)
        let exp = expectation(description: "Test after 1 seconds")
        var resultcapture: [String] = []
        let expectedResult: [String] = ["call 1", "call 2"]
        let promise = expectation(description: "Should return result ")
        // when
        testObj.renewInterval()
        testObj.handler = {
            resultcapture.append("call 1")
        }
        _ = XCTWaiter.wait(for: [exp], timeout: 1.0)
        testObj.renewInterval()
        testObj.handler = {
            resultcapture.append("call 2")
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
        // then
        XCTAssertEqual(2, resultcapture.count, "Not matching result count")
        XCTAssertEqual(expectedResult, resultcapture, "Both called get executed")
    }

//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
