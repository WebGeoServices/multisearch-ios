//
//  ProviderConfigTests.swift
//  MultisearchTests
//
//  Created by apple on 07/05/21.
//

import XCTest
@testable import Multisearch
class ProviderConfigTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testproviderConfigFormat1() throws {
        // given
        // when
        let testObject = ProviderConfig.init(searchType: .localities, key: "test123")

        // then
        XCTAssertEqual(testObject.searchType, .localities)
        XCTAssertEqual(testObject.key, "test123")
        XCTAssertEqual(testObject.fallbackBreakpoint, 0.4)
        XCTAssertEqual(testObject.minInputLength, 0)
        XCTAssertEqual(testObject.ignoreFallbackBreakpoint, false)
        XCTAssertNil(testObject.param)
    }

    func testproviderConfigFormat2() throws {
        // given
        // when
        let testObject = ProviderConfig.init(searchType: .localities, key: "test123", fallbackBreakpoint: 0.5)

        // then
        XCTAssertEqual(testObject.searchType, .localities)
        XCTAssertEqual(testObject.key, "test123")
        XCTAssertEqual(testObject.fallbackBreakpoint, 0.5)
        XCTAssertEqual(testObject.minInputLength, 0)
        XCTAssertEqual(testObject.ignoreFallbackBreakpoint, false)
        XCTAssertNil(testObject.param)
    }
    func testproviderConfigFormat3() throws {
        // given
        // when
        let testObject = ProviderConfig.init(searchType: .localities, key: "test123", fallbackBreakpoint: 0)

        // then
        XCTAssertEqual(testObject.searchType, .localities)
        XCTAssertEqual(testObject.key, "test123")
        XCTAssertEqual(testObject.fallbackBreakpoint, 0)
        XCTAssertEqual(testObject.minInputLength, 0)
        XCTAssertEqual(testObject.ignoreFallbackBreakpoint, true)
        XCTAssertNil(testObject.param)
    }

    func testproviderConfigFormat4() throws {
        // given
        // when
        let testObject = ProviderConfig.init(searchType: .localities, key: "test123", ignoreFallbackBreakpoint: true)

        // then
        XCTAssertEqual(testObject.searchType, .localities)
        XCTAssertEqual(testObject.key, "test123")
        XCTAssertEqual(testObject.fallbackBreakpoint, 0)
        XCTAssertEqual(testObject.minInputLength, 0)
        XCTAssertEqual(testObject.ignoreFallbackBreakpoint, true)
        XCTAssertNil(testObject.param)
    }

    func testproviderConfigFormat5() throws {
        // given
        // when
        let testObject = ProviderConfig.init(searchType: .localities, key: "test123", ignoreFallbackBreakpoint: false)

        // then
        XCTAssertEqual(testObject.searchType, .localities)
        XCTAssertEqual(testObject.key, "test123")
        XCTAssertEqual(testObject.fallbackBreakpoint, 0.4)
        XCTAssertEqual(testObject.minInputLength, 0)
        XCTAssertEqual(testObject.ignoreFallbackBreakpoint, false)
        XCTAssertNil(testObject.param)
    }

    func testproviderConfigFormat6() throws {
        // given
        // when
        let testObject = ProviderConfig.init(searchType: .localities, key: "test123", minInputLength: 5)

        // then
        XCTAssertEqual(testObject.searchType, .localities)
        XCTAssertEqual(testObject.key, "test123")
        XCTAssertEqual(testObject.fallbackBreakpoint, 0.4)
        XCTAssertEqual(testObject.minInputLength, 5)
        XCTAssertEqual(testObject.ignoreFallbackBreakpoint, false)
        XCTAssertNil(testObject.param)
    }

    func testproviderConfigFormat7() throws {
        // given
        // when
        let testObject = ProviderConfig.init(searchType: .localities, key: "test123", param: ConfigParam.init())

        // then
        XCTAssertEqual(testObject.searchType, .localities)
        XCTAssertEqual(testObject.key, "test123")
        XCTAssertEqual(testObject.fallbackBreakpoint, 0.4)
        XCTAssertEqual(testObject.minInputLength, 0)
        XCTAssertEqual(testObject.ignoreFallbackBreakpoint, false)
        XCTAssertNotNil(testObject.param)
    }

}
