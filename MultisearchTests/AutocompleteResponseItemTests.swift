//
//  AutocompleteResponseItemTests.swift
//  MultisearchTests
//
//  Created by apple on 07/05/21.
//

import XCTest
@testable import Multisearch

class AutocompleteResponseItemTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAutocompleteResponseItem_format1() throws {
        // given

        // when
        let testObject: AutocompleteResponseItem = AutocompleteResponseItem.init(
            description: "Test AutocompleteResponseItem",
            searchtype: .localities, input: ["public_id": "123",
                                             "type": "type1"])

        // then
        XCTAssertEqual(testObject.description, "Test AutocompleteResponseItem")
        XCTAssertEqual(testObject.api, .localities)
        XCTAssertEqual(testObject.id, "123")
        XCTAssertEqual(testObject.types, ["type1"])
    }

    func testAutocompleteResponseItem_format2() throws {
        // given

        // when
        let testObject: AutocompleteResponseItem = AutocompleteResponseItem.init(
            description: "Test AutocompleteResponseItem",
            searchtype: .localities,
            input: ["public_id": "123",
                    "types": ["type1", "type2"]])

        // then
        XCTAssertEqual(testObject.description, "Test AutocompleteResponseItem")
        XCTAssertEqual(testObject.api, .localities)
        XCTAssertEqual(testObject.id, "123")
        XCTAssertEqual(testObject.types, ["type1", "type2"])
    }

    func testAutocompleteResponseItem_format3() throws {
        // given

        // when
        let testObject: AutocompleteResponseItem = AutocompleteResponseItem.init(
            description: "Test AutocompleteResponseItem",
            searchtype: .localities,
            input: ["place_id": "123",
                    "types": ["type1", "type2"]])

        // then
        XCTAssertEqual(testObject.description, "Test AutocompleteResponseItem")
        XCTAssertEqual(testObject.api, .localities)
        XCTAssertEqual(testObject.id, "123")
        XCTAssertEqual(testObject.types, ["type1", "type2"])
    }

    func testAutocompleteResponseItem_format4() throws {
        // given

        // when
        let testObject: AutocompleteResponseItem = AutocompleteResponseItem.init(
            description: "Test AutocompleteResponseItem",
            searchtype: .localities,
            input: ["store_id": "123",
                    "types": ["type1", "type2"]])

        // then
        XCTAssertEqual(testObject.description, "Test AutocompleteResponseItem")
        XCTAssertEqual(testObject.api, .localities)
        XCTAssertEqual(testObject.id, "123")
        XCTAssertEqual(testObject.types, ["type1", "type2"])
    }

    func testAutocompleteResponseItem_format5() throws {
        // given

        // when
        let testObject: AutocompleteResponseItem = AutocompleteResponseItem.init(
            description: "Test AutocompleteResponseItem",
            searchtype: .localities,
            input: ["store_id": "123",
                    "types": ["type1", "type2"],
                    "matched_substrings": ["description": [["length": Int64(2),
                                                            "offset": Int64(1)],
                                                         ["length": Int64(3),
                                                          "offset": Int64(10)]]]])

        // then
        XCTAssertEqual(testObject.description, "Test AutocompleteResponseItem")
        XCTAssertEqual(testObject.api, .localities)
        XCTAssertEqual(testObject.id, "123")
        XCTAssertEqual(testObject.types, ["type1", "type2"])
        XCTAssertEqual(testObject.matchedSubstrings, [NSRange.init(location: 1, length: 2), NSRange.init(location: 10, length: 3)])
        XCTAssertEqual(testObject.highlight, "T<mark>es</mark>t Autoc<mark>omp</mark>leteResponseItem")
    }

    func testAutocompleteResponseItem_format6() throws {
        // given

        // when
        let testObject: AutocompleteResponseItem = AutocompleteResponseItem.init(
            description: "Test AutocompleteResponseItem",
            searchtype: .localities,
            input: ["store_id": "123",
                    "types": ["type1", "type2"],
                    "matched_substrings": [["length": Int64(2),
                                                            "offset": Int64(1)],
                                                         ["length": Int64(3),
                                                          "offset": Int64(10)]]])

        // then
        XCTAssertEqual(testObject.description, "Test AutocompleteResponseItem")
        XCTAssertEqual(testObject.api, .localities)
        XCTAssertEqual(testObject.id, "123")
        XCTAssertEqual(testObject.types, ["type1", "type2"])
        XCTAssertEqual(testObject.matchedSubstrings, [NSRange.init(location: 1, length: 2), NSRange.init(location: 10, length: 3)])
        XCTAssertEqual(testObject.highlight, "T<mark>es</mark>t Autoc<mark>omp</mark>leteResponseItem")
    }

    func testAutocompleteResponseItem_format7() throws {
        // given
        // when
        let testObject: AutocompleteResponseItem = AutocompleteResponseItem.init(
            description: "Test AutocompleteResponseItem",
            searchtype: .localities,
            input: ["store_id": "123",
                    "types": ["type1", "type2"],
                    "matched_substring": ["description": [["length": Int64(2),
                                                            "offset": Int64(1)],
                                                         ]]])

        // then
        XCTAssertEqual(testObject.description, "Test AutocompleteResponseItem")
        XCTAssertEqual(testObject.api, .localities)
        XCTAssertEqual(testObject.id, "123")
        XCTAssertEqual(testObject.types, ["type1", "type2"])
        XCTAssertEqual(testObject.matchedSubstrings, [NSRange.init(location: 1, length: 2)])
        XCTAssertEqual(testObject.highlight, "T<mark>es</mark>t AutocompleteResponseItem")
    }

}
