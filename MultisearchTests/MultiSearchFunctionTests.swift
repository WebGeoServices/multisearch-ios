//
//  MultiSearchFunctionTests.swift
//  MultisearchTests
//
//  Created by apple on 06/05/21.
//

import XCTest
@testable import Multisearch

class MultiSearchFunctionTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testautocomplete_Row3() throws {
        // given
        let testObject = MultiSearch.init(debounceTime: 100)
        let localitiesProvider: ProviderConfig = ProviderConfig(searchType: .localities,
                                                                key: FakeTestData.woosmapKey,
                                                                fallbackBreakpoint: 0.4,
                                                                param: ConfigParam(components: Components(country: ["fr"]),
                                                                                   types: ["locality", "postal_code"],
                                                                                   language: "fr"))
        let addressProvider: ProviderConfig = ProviderConfig(searchType: .address,
                                                             key: FakeTestData.woosmapKey,
                                                             fallbackBreakpoint: 0.5,
                                                             minInputLength: 1,
                                                             param: ConfigParam(components: Components(country: ["fr"]),
                                                                                language: "fr"))
        let storeProvider: ProviderConfig = ProviderConfig(searchType: .store,
                                                           key: FakeTestData.woosmapKey,
                                                           ignoreFallbackBreakpoint: true,
                                                           minInputLength: 1,
                                                           param: ConfigParam( query: "type:bose_store"))

        let placesProvider: ProviderConfig = ProviderConfig(searchType: .places,
                                                            key: FakeTestData.placesKey,
                                                            fallbackBreakpoint: 1,
                                                            minInputLength: 8,
                                                            param: ConfigParam(components: Components(country: ["fr"])))

        testObject.addProvider(config: localitiesProvider)
        testObject.addProvider(config: addressProvider)
        testObject.addProvider(config: storeProvider)
        testObject.addProvider(config: placesProvider)

        var responseError: WoosmapError?
        var responseResult: [AutocompleteResponseItem]?

        let promise = expectation(description: "Should return result")
        // when
        testObject.autocompleteMulti(input: "23 rue de") { (result, error) in
            responseResult = result
            responseError = error
            promise.fulfill()
        }

        wait(for: [promise], timeout: 5)

        // then
        XCTAssertNil(responseError, "function should not return errors")
        XCTAssertEqual(5, responseResult?.count, "No Matching record counts")
        XCTAssertEqual("23 Rue Delizy, 93500 Pantin, France", responseResult?.first?.description, "No Matching Details of result")

        let recordLocalities = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .localities
        })
        XCTAssertNil(recordLocalities, "As per config localities record should not be fetch")

        let recordStore = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .store
        })
        XCTAssertNil(recordStore, "As per config store record should be not fetch")

        let recordAddress = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .address
        })
        XCTAssertNotNil(recordAddress, "As per config address record should be fetch")

    }

    func testautocomplete_Row4() throws {
        // given
        let testObject = MultiSearch.init(debounceTime: 100)
        let localitiesProvider: ProviderConfig = ProviderConfig(searchType: .localities,
                                                                key: FakeTestData.woosmapKey,
                                                                fallbackBreakpoint: 0.4,
                                                                param: ConfigParam(components: Components(country: ["fr"]),
                                                                                   types: ["locality", "postal_code"],
                                                                                   language: "fr"))
        let addressProvider: ProviderConfig = ProviderConfig(searchType: .address,
                                                             key: FakeTestData.woosmapKey,
                                                             fallbackBreakpoint: 0.5,
                                                             minInputLength: 1,
                                                             param: ConfigParam(components: Components(country: ["fr"]),
                                                                                language: "fr"))
        let storeProvider: ProviderConfig = ProviderConfig(searchType: .store,
                                                           key: FakeTestData.woosmapKey,
                                                           ignoreFallbackBreakpoint: true,
                                                           minInputLength: 1,
                                                           param: ConfigParam( query: "type:bose_store"))

        let placesProvider: ProviderConfig = ProviderConfig(searchType: .places,
                                                            key: FakeTestData.placesKey,
                                                            fallbackBreakpoint: 1,
                                                            minInputLength: 8,
                                                            param: ConfigParam(components: Components(country: ["fr"])))

        testObject.addProvider(config: localitiesProvider)
        testObject.addProvider(config: addressProvider)
        testObject.addProvider(config: storeProvider)
        testObject.addProvider(config: placesProvider)

        var responseError: WoosmapError?
        var responseResult: [AutocompleteResponseItem]?

        let promise = expectation(description: "Should return result")
        // when
        testObject.autocompleteMulti(input: "Montp") { (result, error) in
            responseResult = result
            responseError = error
            promise.fulfill()
        }

        wait(for: [promise], timeout: 5)

        // then
        XCTAssertNil(responseError, "function should not return errors")
        XCTAssertEqual(5, responseResult?.count, "No Matching record counts")
        XCTAssertEqual("Montpellier, Hérault, France", responseResult?.first?.description, "No Matching Details of result")

        let recordLocalities = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .localities
        })
        XCTAssertNotNil(recordLocalities, "As per config localities record should be fetch")

        let recordStore = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .store
        })
        XCTAssertNil(recordStore, "As per config store record should be not fetch")

        let recordAddress = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .address
        })
        XCTAssertNil(recordAddress, "As per config address record should not be fetch")

    }

    func testautocomplete_Row5() throws {
        // given
        let testObject = MultiSearch.init(debounceTime: 100)
        let localitiesProvider: ProviderConfig = ProviderConfig(searchType: .localities,
                                                                key: FakeTestData.woosmapKey,
                                                                fallbackBreakpoint: 0.4,
                                                                param: ConfigParam(components: Components(country: ["fr"]),
                                                                                   types: ["locality", "postal_code"],
                                                                                   language: "fr"))
        let addressProvider: ProviderConfig = ProviderConfig(searchType: .address,
                                                             key: FakeTestData.woosmapKey,
                                                             fallbackBreakpoint: 0.5,
                                                             minInputLength: 1,
                                                             param: ConfigParam(components: Components(country: ["fr"]),
                                                                                language: "fr"))
        let storeProvider: ProviderConfig = ProviderConfig(searchType: .store,
                                                           key: FakeTestData.woosmapKey,
                                                           ignoreFallbackBreakpoint: true,
                                                           minInputLength: 1,
                                                           param: ConfigParam( query: "type:bose_store"))

        let placesProvider: ProviderConfig = ProviderConfig(searchType: .places,
                                                            key: FakeTestData.placesKey,
                                                            fallbackBreakpoint: 1,
                                                            minInputLength: 8,
                                                            param: ConfigParam(components: Components(country: ["fr"])))

        testObject.addProvider(config: localitiesProvider)
        testObject.addProvider(config: addressProvider)
        testObject.addProvider(config: storeProvider)
        testObject.addProvider(config: placesProvider)

        var responseError: WoosmapError?
        var responseResult: [AutocompleteResponseItem]?

        let promise = expectation(description: "Should return result")
        // when
        testObject.autocompleteMulti(input: "Disneyla") { (result, error) in
            responseResult = result
            responseError = error
            promise.fulfill()
        }

        wait(for: [promise], timeout: 5)

        // then
        XCTAssertNil(responseError, "function should not return errors")
        XCTAssertEqual(5, responseResult?.count, "No Matching record counts")
        XCTAssertEqual("Disneyland Paris, Boulevard de Parc, Coupvray, France", responseResult?.first?.description, "No Matching Details of result")

        let recordLocalities = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .localities
        })
        XCTAssertNil(recordLocalities, "As per config localities record should not be fetch")

        let recordStore = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .store
        })
        XCTAssertNil(recordStore, "As per config store record should be not fetch")

        let recordAddress = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .address
        })
        XCTAssertNil(recordAddress, "As per config address record should not be fetch")

        let recordPlace = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .places
        })
        XCTAssertNotNil(recordPlace, "As per config address record should be fetch")

    }

    func testautocomplete_Row6() throws {
        // given
        let testObject = MultiSearch.init(debounceTime: 100)
        let localitiesProvider: ProviderConfig = ProviderConfig(searchType: .localities,
                                                                key: FakeTestData.woosmapKey,
                                                                fallbackBreakpoint: 0.4,
                                                                param: ConfigParam(components: Components(country: ["fr"]),
                                                                                   types: ["locality", "postal_code"],
                                                                                   language: "fr"))
        let addressProvider: ProviderConfig = ProviderConfig(searchType: .address,
                                                             key: FakeTestData.woosmapKey,
                                                             fallbackBreakpoint: 0.5,
                                                             minInputLength: 1,
                                                             param: ConfigParam(components: Components(country: ["fr"]),
                                                                                language: "fr"))
        let storeProvider: ProviderConfig = ProviderConfig(searchType: .store,
                                                           key: FakeTestData.woosmapKey,
                                                           ignoreFallbackBreakpoint: true,
                                                           minInputLength: 1,
                                                           param: ConfigParam( query: "type:bose_store"))

        let placesProvider: ProviderConfig = ProviderConfig(searchType: .places,
                                                            key: FakeTestData.placesKey,
                                                            fallbackBreakpoint: 1,
                                                            minInputLength: 8,
                                                            param: ConfigParam(components: Components(country: ["fr"])))

        testObject.addProvider(config: localitiesProvider)
        testObject.addProvider(config: addressProvider)
        testObject.addProvider(config: storeProvider)
        testObject.addProvider(config: placesProvider)

        var responseError: WoosmapError?
        var responseResult: [AutocompleteResponseItem]?

        let promise = expectation(description: "Should return result")
        // when
        testObject.autocompleteMulti(input: "34170") { (result, error) in
            responseResult = result
            responseError = error
            promise.fulfill()
        }

        wait(for: [promise], timeout: 5)

        // then
        XCTAssertNil(responseError, "function should not return errors")
        XCTAssertEqual(5, responseResult?.count, "No Matching record counts")
        XCTAssertEqual("34170, Castelnau-le-Lez, France", responseResult?.first?.description, "No Matching Details of result")

        let recordLocalities = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .localities
        })
        XCTAssertNotNil(recordLocalities, "As per config localities record should be fetch")

        let recordStore = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .store
        })
        XCTAssertNil(recordStore, "As per config store record should be not fetch")

        let recordAddress = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .address
        })
        XCTAssertNil(recordAddress, "As per config address record should not be fetch")

        let recordPlace = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .places
        })
        XCTAssertNil(recordPlace, "As per config address record should not be fetch")

    }

    func testautocomplete_Row9() throws {
        // given
        let testObject = MultiSearch.init(debounceTime: 100)
        let localitiesProvider: ProviderConfig = ProviderConfig(searchType: .localities,
                                                                key: FakeTestData.woosmapKey,
                                                                fallbackBreakpoint: 0.4,
                                                                param: ConfigParam(components: Components(country: ["gb"]),
                                                                                   types: ["locality", "postal_code"],
                                                                                   language: "gb"))
        let addressProvider: ProviderConfig = ProviderConfig(searchType: .address,
                                                             key: FakeTestData.woosmapKey,
                                                             fallbackBreakpoint: 0.5,
                                                             minInputLength: 5,
                                                             param: ConfigParam(components: Components(country: ["gb"]),
                                                                                language: "gb"))
        let storeProvider: ProviderConfig = ProviderConfig(searchType: .store,
                                                           key: FakeTestData.woosmapKey,
                                                           ignoreFallbackBreakpoint: true,
                                                           param: ConfigParam( query: "type:bose_store"))

        let placesProvider: ProviderConfig = ProviderConfig(searchType: .places,
                                                            key: FakeTestData.placesKey,
                                                            fallbackBreakpoint: 1,
                                                            minInputLength: 8,
                                                            param: ConfigParam(components: Components(country: ["gb"])))

        testObject.addProvider(config: storeProvider)
        testObject.addProvider(config: localitiesProvider)
        testObject.addProvider(config: addressProvider)
        testObject.addProvider(config: placesProvider)

        var responseError: WoosmapError?
        var responseResult: [AutocompleteResponseItem]?

        let promise = expectation(description: "Should return result")
        // when
        testObject.autocompleteMulti(input: "She") { (result, error) in
            responseResult = result
            responseError = error
            promise.fulfill()
        }

        wait(for: [promise], timeout: 5)

        // then
        XCTAssertNil(responseError, "function should not return errors")
        XCTAssertEqual(5, responseResult?.count, "No Matching record counts")
        XCTAssertEqual("Sheffield, South Yorkshire, United Kingdom", responseResult?.first?.description, "No Matching Details of result")

        let recordLocalities = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .localities
        })
        XCTAssertNotNil(recordLocalities, "As per config localities record should be fetch")

        let recordStore = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .store
        })
        XCTAssertNil(recordStore, "As per config store record should be fetch")

        let recordAddress = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .address
        })
        XCTAssertNil(recordAddress, "As per config address record should not be fetch")

        let recordPlace = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .places
        })
        XCTAssertNil(recordPlace, "As per config address record should not be fetch")

    }

    func testautocomplete_Row10() throws {
        // given
        let testObject = MultiSearch.init(debounceTime: 100)
        let localitiesProvider: ProviderConfig = ProviderConfig(searchType: .localities,
                                                                key: FakeTestData.woosmapKey,
                                                                fallbackBreakpoint: 0.4,
                                                                param: ConfigParam(components: Components(country: ["gb"]),
                                                                                   types: ["locality", "postal_code"],
                                                                                   language: "gb"))
        let addressProvider: ProviderConfig = ProviderConfig(searchType: .address,
                                                             key: FakeTestData.woosmapKey,
                                                             fallbackBreakpoint: 0.5,
                                                             minInputLength: 5,
                                                             param: ConfigParam(components: Components(country: ["gb"]),
                                                                                language: "gb"))
        let storeProvider: ProviderConfig = ProviderConfig(searchType: .store,
                                                           key: FakeTestData.woosmapKey,
                                                           ignoreFallbackBreakpoint: true,
                                                           param: ConfigParam( query: "type:bose_store"))

        let placesProvider: ProviderConfig = ProviderConfig(searchType: .places,
                                                            key: FakeTestData.placesKey,
                                                            fallbackBreakpoint: 1,
                                                            minInputLength: 8,
                                                            param: ConfigParam(components: Components(country: ["gb"])))

        testObject.addProvider(config: storeProvider)
        testObject.addProvider(config: localitiesProvider)
        testObject.addProvider(config: addressProvider)
        testObject.addProvider(config: placesProvider)

        var responseError: WoosmapError?
        var responseResult: [AutocompleteResponseItem]?

        let promise = expectation(description: "Should return result")
        // when
        testObject.autocompleteMulti(input: "Lanc") { (result, error) in
            responseResult = result
            responseError = error
            promise.fulfill()
        }

        wait(for: [promise], timeout: 5)

        // then
        XCTAssertNil(responseError, "function should not return errors")
        XCTAssertEqual(5, responseResult?.count, "No Matching record counts")
        XCTAssertEqual("Lancaster, Lancashire, United Kingdom", responseResult?.first?.description, "No Matching Details of result")

        let recordLocalities = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .localities
        })
        XCTAssertNotNil(recordLocalities, "As per config localities record should be fetch")

        let recordStore = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .store
        })
        XCTAssertNil(recordStore, "As per config store record should not be fetch")

        let recordAddress = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .address
        })
        XCTAssertNil(recordAddress, "As per config address record should not be fetch")

        let recordPlace = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .places
        })
        XCTAssertNil(recordPlace, "As per config address record should not be fetch")

    }

    func testautocomplete_Row13() throws {
        // given
        let testObject = MultiSearch.init(debounceTime: 100)
        let localitiesProvider: ProviderConfig = ProviderConfig(searchType: .localities,
                                                                key: FakeTestData.woosmapKey,
                                                                fallbackBreakpoint: 0.4,
                                                                param: ConfigParam(components: Components(country: ["gb"]),
                                                                                   types: ["locality", "postal_code"],
                                                                                   language: "gb"))
        let addressProvider: ProviderConfig = ProviderConfig(searchType: .address,
                                                             key: FakeTestData.woosmapKey,
                                                             fallbackBreakpoint: 0.5,
                                                             minInputLength: 5,
                                                             param: ConfigParam(components: Components(country: ["gb"]),
                                                                                language: "gb"))
        let storeProvider: ProviderConfig = ProviderConfig(searchType: .store,
                                                           key: FakeTestData.woosmapKey,
                                                           ignoreFallbackBreakpoint: true,
                                                           param: ConfigParam( query: "type:bose_store"))

        let placesProvider: ProviderConfig = ProviderConfig(searchType: .places,
                                                            key: FakeTestData.placesKey,
                                                            fallbackBreakpoint: 1,
                                                            minInputLength: 8,
                                                            param: ConfigParam(components: Components(country: ["gb"])))

        testObject.addProvider(config: localitiesProvider)
        testObject.addProvider(config: addressProvider)
        testObject.addProvider(config: placesProvider)
        testObject.addProvider(config: storeProvider)

        var responseError: WoosmapError?
        var responseResult: [AutocompleteResponseItem]?

        let promise = expectation(description: "Should return result")
        // when
        testObject.autocompleteMulti(input: "She") { (result, error) in
            responseResult = result
            responseError = error
            promise.fulfill()
        }

        wait(for: [promise], timeout: 5)

        // then
        XCTAssertNil(responseError, "function should not return errors")
        XCTAssertEqual(5, responseResult?.count, "No Matching record counts")
        XCTAssertEqual("Sheffield, South Yorkshire, United Kingdom", responseResult?.first?.description, "No Matching Details of result")

        let recordLocalities = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .localities
        })
        XCTAssertNotNil(recordLocalities, "As per config localities record should be fetch")

        let recordStore = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .store
        })
        XCTAssertNil(recordStore, "As per config store record should be fetch")

        let recordAddress = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .address
        })
        XCTAssertNil(recordAddress, "As per config address record should not be fetch")

        let recordPlace = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .places
        })
        XCTAssertNil(recordPlace, "As per config address record should not be fetch")

    }

    func testautocomplete_Row14() throws {
        // given
        let testObject = MultiSearch.init(debounceTime: 100)
        let localitiesProvider: ProviderConfig = ProviderConfig(searchType: .localities,
                                                                key: FakeTestData.woosmapKey,
                                                                fallbackBreakpoint: 0.4,
                                                                param: ConfigParam(components: Components(country: ["gb"]),
                                                                                   types: ["locality", "postal_code"],
                                                                                   language: "gb"))
        let addressProvider: ProviderConfig = ProviderConfig(searchType: .address,
                                                             key: FakeTestData.woosmapKey,
                                                             fallbackBreakpoint: 0.5,
                                                             minInputLength: 5,
                                                             param: ConfigParam(components: Components(country: ["gb"]),
                                                                                language: "gb"))
        let storeProvider: ProviderConfig = ProviderConfig(searchType: .store,
                                                           key: FakeTestData.woosmapKey,
                                                           ignoreFallbackBreakpoint: true,
                                                           param: ConfigParam( query: "type:bose_store"))

        let placesProvider: ProviderConfig = ProviderConfig(searchType: .places,
                                                            key: FakeTestData.placesKey,
                                                            fallbackBreakpoint: 1,
                                                            minInputLength: 8,
                                                            param: ConfigParam(components: Components(country: ["gb"])))

        testObject.addProvider(config: localitiesProvider)
        testObject.addProvider(config: addressProvider)
        testObject.addProvider(config: placesProvider)
        testObject.addProvider(config: storeProvider)

        var responseError: WoosmapError?
        var responseResult: [AutocompleteResponseItem]?

        let promise = expectation(description: "Should return result")
        // when
        testObject.autocompleteMulti(input: "Lanc") { (result, error) in
            responseResult = result
            responseError = error
            promise.fulfill()
        }

        wait(for: [promise], timeout: 5)

        // then
        XCTAssertNil(responseError, "function should not return errors")
        XCTAssertEqual(5, responseResult?.count, "No Matching record counts")
        XCTAssertEqual("Lancaster, Lancashire, United Kingdom", responseResult?.first?.description, "No Matching Details of result")

        let recordLocalities = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .localities
        })
        XCTAssertNotNil(recordLocalities, "As per config localities record should be fetch")

        let recordStore = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .store
        })
        XCTAssertNil(recordStore, "As per config store record should not be fetch")

        let recordAddress = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .address
        })
        XCTAssertNil(recordAddress, "As per config address record should not be fetch")

        let recordPlace = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .places
        })
        XCTAssertNil(recordPlace, "As per config address record should not be fetch")

    }

    func testautocomplete_Row17() throws {
        // given
        let testObject = MultiSearch.init(debounceTime: 100)
        let localitiesProvider: ProviderConfig = ProviderConfig(searchType: .localities,
                                                                key: FakeTestData.woosmapKey,
                                                                fallbackBreakpoint: 0.4,
                                                                minInputLength: 3,
                                                                param: ConfigParam(components: Components(country: ["fr"]),
                                                                                   types: ["locality", "postal_code"],
                                                                                   language: "fr"))
        let addressProvider: ProviderConfig = ProviderConfig(searchType: .address,
                                                             key: FakeTestData.woosmapKey,
                                                             fallbackBreakpoint: 0.5,
                                                             minInputLength: 5,
                                                             param: ConfigParam(components: Components(country: ["fr"]),
                                                                                language: "fr"))

        let placesProvider: ProviderConfig = ProviderConfig(searchType: .places,
                                                            key: FakeTestData.placesKey,
                                                            fallbackBreakpoint: 1,
                                                            minInputLength: 8,
                                                            param: ConfigParam(components: Components(country: ["fr"])))

        testObject.addProvider(config: localitiesProvider)
        testObject.addProvider(config: addressProvider)
        testObject.addProvider(config: placesProvider)

        var responseError: WoosmapError?
        var responseResult: [AutocompleteResponseItem]?

        let promise = expectation(description: "Should return result")
        // when
        testObject.autocompleteMulti(input: "Montp") { (result, error) in
            responseResult = result
            responseError = error
            promise.fulfill()
        }

        wait(for: [promise], timeout: 5)

        // then
        XCTAssertNil(responseError, "function should not return errors")
        XCTAssertEqual(5, responseResult?.count, "No Matching record counts")
        XCTAssertEqual("Montpellier, Hérault, France", responseResult?.first?.description, "No Matching Details of result")

        let recordLocalities = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .localities
        })
        XCTAssertNotNil(recordLocalities, "As per config localities record should be fetch")

        let recordStore = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .store
        })
        XCTAssertNil(recordStore, "As per config store record should not be fetch")

        let recordAddress = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .address
        })
        XCTAssertNil(recordAddress, "As per config address record should not be fetch")

        let recordPlace = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .places
        })
        XCTAssertNil(recordPlace, "As per config address record should not be fetch")

    }

    func testautocomplete_Row18() throws {
        // given
        let testObject = MultiSearch.init(debounceTime: 100)
        let localitiesProvider: ProviderConfig = ProviderConfig(searchType: .localities,
                                                                key: FakeTestData.woosmapKey,
                                                                fallbackBreakpoint: 0.4,
                                                                minInputLength: 3,
                                                                param: ConfigParam(components: Components(country: ["fr"]),
                                                                                   types: ["locality", "postal_code"],
                                                                                   language: "fr"))
        let addressProvider: ProviderConfig = ProviderConfig(searchType: .address,
                                                             key: FakeTestData.woosmapKey,
                                                             fallbackBreakpoint: 0.5,
                                                             minInputLength: 5,
                                                             param: ConfigParam(components: Components(country: ["fr"]),
                                                                                language: "fr"))

        let placesProvider: ProviderConfig = ProviderConfig(searchType: .places,
                                                            key: FakeTestData.placesKey,
                                                            fallbackBreakpoint: 1,
                                                            minInputLength: 8,
                                                            param: ConfigParam(components: Components(country: ["fr"])))

        testObject.addProvider(config: localitiesProvider)
        testObject.addProvider(config: addressProvider)
        testObject.addProvider(config: placesProvider)

        var responseError: WoosmapError?
        var responseResult: [AutocompleteResponseItem]?

        let promise = expectation(description: "Should return result")
        // when
        testObject.autocompleteMulti(input: "340") { (result, error) in
            responseResult = result
            responseError = error
            promise.fulfill()
        }

        wait(for: [promise], timeout: 5)

        // then
        XCTAssertNil(responseError, "function should not return errors")
        XCTAssertEqual(4, responseResult?.count, "No Matching record counts")
        XCTAssertEqual("34070, Montpellier, France", responseResult?.first?.description, "No Matching Details of result")

        let recordLocalities = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .localities
        })
        XCTAssertNotNil(recordLocalities, "As per config localities record should be fetch")

        let recordStore = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .store
        })
        XCTAssertNil(recordStore, "As per config store record should not be fetch")

        let recordAddress = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .address
        })
        XCTAssertNil(recordAddress, "As per config address record should not be fetch")

        let recordPlace = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .places
        })
        XCTAssertNil(recordPlace, "As per config address record should not be fetch")

    }

    func testautocomplete_Row21() throws {
        // given
        let testObject = MultiSearch.init(debounceTime: 100)
        let localitiesProvider: ProviderConfig = ProviderConfig(searchType: .localities,
                                                                key: FakeTestData.woosmapKey,
                                                                fallbackBreakpoint: 0.4,
                                                                minInputLength: 3,
                                                                param: ConfigParam(components: Components(country: ["fr"]),
                                                                                   types: ["metro_station"],
                                                                                   language: "fr"))
        let addressProvider: ProviderConfig = ProviderConfig(searchType: .address,
                                                             key: FakeTestData.woosmapKey,
                                                             fallbackBreakpoint: 0.5,
                                                             minInputLength: 5,
                                                             param: ConfigParam(components: Components(country: ["fr"]),
                                                                                language: "fr"))

        let placesProvider: ProviderConfig = ProviderConfig(searchType: .places,
                                                            key: FakeTestData.placesKey,
                                                            fallbackBreakpoint: 1,
                                                            minInputLength: 8,
                                                            param: ConfigParam(components: Components(country: ["fr"])))

        testObject.addProvider(config: localitiesProvider)
        testObject.addProvider(config: addressProvider)
        testObject.addProvider(config: placesProvider)

        var responseError: WoosmapError?
        var responseResult: [AutocompleteResponseItem]?

        let promise = expectation(description: "Should return result")
        // when
        testObject.autocompleteMulti(input: "Montp") { (result, error) in
            responseResult = result
            responseError = error
            promise.fulfill()
        }

        wait(for: [promise], timeout: 5)

        // then
        XCTAssertNil(responseError, "function should not return errors")
        XCTAssertEqual(5, responseResult?.count, "No Matching record counts")
        XCTAssertEqual("Montparnasse-Bienvenüe, Paris, France", responseResult?.first?.description, "No Matching Details of result")

        let recordLocalities = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .localities
        })
        XCTAssertNotNil(recordLocalities, "As per config localities record should be fetch")

        let recordStore = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .store
        })
        XCTAssertNil(recordStore, "As per config store record should not be fetch")

        let recordAddress = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .address
        })
        XCTAssertNil(recordAddress, "As per config address record should not be fetch")

        let recordPlace = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .places
        })
        XCTAssertNil(recordPlace, "As per config address record should not be fetch")

    }

    func testautocomplete_Row22() throws {
        // given
        let testObject = MultiSearch.init(debounceTime: 100)
        let localitiesProvider: ProviderConfig = ProviderConfig(searchType: .localities,
                                                                key: FakeTestData.woosmapKey,
                                                                fallbackBreakpoint: 0.4,
                                                                minInputLength: 3,
                                                                param: ConfigParam(components: Components(country: ["fr"]),
                                                                                   types: ["metro_station"],
                                                                                   language: "fr"))
        let addressProvider: ProviderConfig = ProviderConfig(searchType: .address,
                                                             key: FakeTestData.woosmapKey,
                                                             fallbackBreakpoint: 0.5,
                                                             minInputLength: 5,
                                                             param: ConfigParam(components: Components(country: ["fr"]),
                                                                                language: "fr"))

        let placesProvider: ProviderConfig = ProviderConfig(searchType: .places,
                                                            key: FakeTestData.placesKey,
                                                            fallbackBreakpoint: 1,
                                                            minInputLength: 8,
                                                            param: ConfigParam(components: Components(country: ["fr"])))

        testObject.addProvider(config: localitiesProvider)
        testObject.addProvider(config: addressProvider)
        testObject.addProvider(config: placesProvider)

        var responseError: WoosmapError?
        var responseResult: [AutocompleteResponseItem]?

        let promise = expectation(description: "Should return result")
        // when
        testObject.autocompleteMulti(input: "Gar") { (result, error) in
            responseResult = result
            responseError = error
            promise.fulfill()
        }

        wait(for: [promise], timeout: 5)

        // then
        XCTAssertNil(responseError, "function should not return errors")
        XCTAssertEqual(5, responseResult?.count, "No Matching record counts")
        XCTAssertEqual("Gare d'Austerlitz, Paris, France", responseResult?.first?.description, "No Matching Details of result")

        let recordLocalities = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .localities
        })
        XCTAssertNotNil(recordLocalities, "As per config localities record should be fetch")

        let recordStore = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .store
        })
        XCTAssertNil(recordStore, "As per config store record should not be fetch")

        let recordAddress = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .address
        })
        XCTAssertNil(recordAddress, "As per config address record should not be fetch")

        let recordPlace = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .places
        })
        XCTAssertNil(recordPlace, "As per config address record should not be fetch")

    }

    func testautocomplete_Row25() throws {
        // given
        let testObject = MultiSearch.init(debounceTime: 100)
        let localitiesProvider: ProviderConfig = ProviderConfig(searchType: .localities,
                                                                key: FakeTestData.woosmapKey,
                                                                fallbackBreakpoint: 0.4,
                                                                minInputLength: 3,
                                                                param: ConfigParam(components: Components(country: ["gb"]),
                                                                                   types: ["locality", "address", "postal_code"],
                                                                                   language: "en"))

        testObject.addProvider(config: localitiesProvider)

        var responseError: WoosmapError?
        var responseResult: [AutocompleteResponseItem]?

        let promise = expectation(description: "Should return result")
        // when
        testObject.autocompleteMulti(input: "KT8 0AE Su") { (result, error) in
            responseResult = result
            responseError = error
            promise.fulfill()
        }

        wait(for: [promise], timeout: 5)

        // then
        XCTAssertNil(responseError, "function should not return errors")
        XCTAssertEqual(5, responseResult?.count, "No Matching record counts")
        XCTAssertEqual("KT8 0AE, Surrey, United Kingdom", responseResult?.first?.description, "No Matching Details of result")

        let recordLocalities = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .localities
        })
        XCTAssertNotNil(recordLocalities, "As per config localities record should be fetch")

        let recordStore = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .store
        })
        XCTAssertNil(recordStore, "As per config store record should not be fetch")

        let recordAddress = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .address
        })
        XCTAssertNil(recordAddress, "As per config address record should not be fetch")

        let recordPlace = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .places
        })
        XCTAssertNil(recordPlace, "As per config address record should not be fetch")

    }

    func testautocomplete_Row26() throws {
        // given
        let testObject = MultiSearch.init(debounceTime: 100)
        let localitiesProvider: ProviderConfig = ProviderConfig(searchType: .localities,
                                                                key: FakeTestData.woosmapKey,
                                                                fallbackBreakpoint: 0.4,
                                                                minInputLength: 3,
                                                                param: ConfigParam(components: Components(country: ["gb"]),
                                                                                   types: ["locality", "address", "postal_code"],
                                                                                   language: "en"))

        testObject.addProvider(config: localitiesProvider)

        var responseError: WoosmapError?
        var responseResult: [AutocompleteResponseItem]?

        let promise = expectation(description: "Should return result")
        // when
        testObject.autocompleteMulti(input: "2 pillor") { (result, error) in
            responseResult = result
            responseError = error
            promise.fulfill()
        }

        wait(for: [promise], timeout: 5)

        // then
        XCTAssertNil(responseError, "function should not return errors")
        XCTAssertEqual(5, responseResult?.count, "No Matching record counts")
        XCTAssertEqual("Spatial, 2 Pillory Street, Nantwich, CW5 5BD, United Kingdom", responseResult?.first?.description, "No Matching Details of result")

        let recordLocalities = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .localities
        })
        XCTAssertNotNil(recordLocalities, "As per config localities record should be fetch")

        let recordStore = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .store
        })
        XCTAssertNil(recordStore, "As per config store record should not be fetch")

        let recordAddress = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .address
        })
        XCTAssertNil(recordAddress, "As per config address record should not be fetch")

        let recordPlace = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .places
        })
        XCTAssertNil(recordPlace, "As per config address record should not be fetch")

    }

    func testautocomplete_Row27() throws {
        // given
        let testObject = MultiSearch.init(debounceTime: 100)
        let localitiesProvider: ProviderConfig = ProviderConfig(searchType: .localities,
                                                                key: FakeTestData.woosmapKey,
                                                                fallbackBreakpoint: 0.4,
                                                                minInputLength: 3,
                                                                param: ConfigParam(components: Components(country: ["gb"]),
                                                                                   types: ["locality", "address", "postal_code"],
                                                                                   language: "en"))

        testObject.addProvider(config: localitiesProvider)

        var responseError: WoosmapError?
        var responseResult: [AutocompleteResponseItem]?

        let promise = expectation(description: "Should return result")
        // when
        testObject.autocompleteMulti(input: "25 dean street newc") { (result, error) in
            responseResult = result
            responseError = error
            promise.fulfill()
        }

        wait(for: [promise], timeout: 5)

        // then
        XCTAssertNil(responseError, "function should not return errors")
        XCTAssertEqual(5, responseResult?.count, "No Matching record counts")
        XCTAssertEqual("Crispy Bites, 25 Dean Street, Newcastle Upon Tyne, NE1 1PQ, United Kingdom", responseResult?.first?.description, "No Matching Details of result")

        let recordLocalities = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .localities
        })
        XCTAssertNotNil(recordLocalities, "As per config localities record should be fetch")

        let recordStore = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .store
        })
        XCTAssertNil(recordStore, "As per config store record should not be fetch")

        let recordAddress = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .address
        })
        XCTAssertNil(recordAddress, "As per config address record should not be fetch")

        let recordPlace = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .places
        })
        XCTAssertNil(recordPlace, "As per config address record should not be fetch")

    }

    func testautocomplete_Row30() throws {
        // given
        let testObject = MultiSearch.init(debounceTime: 100)
        let localitiesProvider: ProviderConfig = ProviderConfig(searchType: .localities,
                                                                key: FakeTestData.woosmapKey,
                                                                minInputLength: 3,
                                                                param: ConfigParam(components: Components(country: ["gb"]),
                                                                                   types: ["locality", "postal_code"],
                                                                                   language: "fr"))
        let addressProvider: ProviderConfig = ProviderConfig(searchType: .address,
                                                             key: FakeTestData.woosmapKey,
                                                             minInputLength: 5,
                                                             param: ConfigParam(components: Components(country: ["fr"]),
                                                                                language: "fr"))

        let placesProvider: ProviderConfig = ProviderConfig(searchType: .places,
                                                            key: FakeTestData.placesKey,
                                                            minInputLength: 2,
                                                            param: ConfigParam(components: Components(country: ["fr"]), language: "fr"))

        testObject.addProvider(config: localitiesProvider)
        testObject.addProvider(config: addressProvider)
        testObject.addProvider(config: placesProvider)

        var responseError: WoosmapError?
        var responseResult: [AutocompleteResponseItem]?

        let promise = expectation(description: "Should return result")
        // when
        testObject.autocompleteMulti(input: "Londres") { (result, error) in
            responseResult = result
            responseError = error
            promise.fulfill()
        }

        wait(for: [promise], timeout: 5)

        // then
        XCTAssertNil(responseError, "function should not return errors")
        XCTAssertEqual(3, responseResult?.count, "No Matching record counts")
        XCTAssertEqual("Londres, City of London, Royaume-Uni", responseResult?.first?.description, "No Matching Details of result")

        let recordLocalities = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .localities
        })
        XCTAssertNotNil(recordLocalities, "As per config localities record should be fetch")

        let recordStore = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .store
        })
        XCTAssertNil(recordStore, "As per config store record should not be fetch")

        let recordAddress = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .address
        })
        XCTAssertNil(recordAddress, "As per config address record should not be fetch")

        let recordPlace = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .places
        })
        XCTAssertNil(recordPlace, "As per config address record should not be fetch")

    }

    func testautocomplete_Row31() throws {
        // given
        let testObject = MultiSearch.init(debounceTime: 100)
        let localitiesProvider: ProviderConfig = ProviderConfig(searchType: .localities,
                                                                key: FakeTestData.woosmapKey,
                                                                minInputLength: 3,
                                                                param: ConfigParam(components: Components(country: ["gb"]),
                                                                                   types: ["locality", "postal_code"],
                                                                                   language: "fr"))
        let addressProvider: ProviderConfig = ProviderConfig(searchType: .address,
                                                             key: FakeTestData.woosmapKey,
                                                             minInputLength: 5,
                                                             param: ConfigParam(components: Components(country: ["fr"]),
                                                                                language: "fr"))

        let placesProvider: ProviderConfig = ProviderConfig(searchType: .places,
                                                            key: FakeTestData.placesKey,
                                                            minInputLength: 2,
                                                            param: ConfigParam(components: Components(country: ["fr"]), language: "fr"))

        testObject.addProvider(config: localitiesProvider)
        testObject.addProvider(config: addressProvider)
        testObject.addProvider(config: placesProvider)

        var responseError: WoosmapError?
        var responseResult: [AutocompleteResponseItem]?

        let promise = expectation(description: "Should return result")
        // when
        testObject.autocompleteMulti(input: "Cité") { (result, error) in
            responseResult = result
            responseError = error
            promise.fulfill()
        }

        wait(for: [promise], timeout: 5)

        // then
        XCTAssertNil(responseError, "function should not return errors")
        XCTAssertEqual(5, responseResult?.count, "No Matching record counts")
        XCTAssertEqual("Cité de Londres, City of London, Royaume-Uni", responseResult?.first?.description, "No Matching Details of result")

        let recordLocalities = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .localities
        })
        XCTAssertNotNil(recordLocalities, "As per config localities record should be fetch")

        let recordStore = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .store
        })
        XCTAssertNil(recordStore, "As per config store record should not be fetch")

        let recordAddress = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .address
        })
        XCTAssertNil(recordAddress, "As per config address record should not be fetch")

        let recordPlace = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .places
        })
        XCTAssertNil(recordPlace, "As per config address record should not be fetch")

    }

    func testautocomplete_Row34() throws {
        // given
        let testObject = MultiSearch.init(debounceTime: 100)
        let localitiesProvider: ProviderConfig = ProviderConfig(searchType: .localities,
                                                                key: FakeTestData.woosmapKey,
                                                                minInputLength: 3,
                                                                param: ConfigParam(components: Components(country: ["fr", "gb"]),
                                                                                   types: ["locality", "postal_code"],
                                                                                   language: "en"))
        let addressProvider: ProviderConfig = ProviderConfig(searchType: .address,
                                                             key: FakeTestData.woosmapKey,
                                                             minInputLength: 5,
                                                             param: ConfigParam(components: Components(country: ["fr"]),
                                                                                language: "fr"))

        let placesProvider: ProviderConfig = ProviderConfig(searchType: .places,
                                                            key: FakeTestData.placesKey,
                                                            minInputLength: 2,
                                                            param: ConfigParam(components: Components(country: ["fr"]), language: "fr"))

        testObject.addProvider(config: localitiesProvider)
        testObject.addProvider(config: addressProvider)
        testObject.addProvider(config: placesProvider)

        var responseError: WoosmapError?
        var responseResult: [AutocompleteResponseItem]?

        let promise = expectation(description: "Should return result")
        // when
        testObject.autocompleteMulti(input: "Lon") { (result, error) in
            responseResult = result
            responseError = error
            promise.fulfill()
        }

        wait(for: [promise], timeout: 5)

        // then
        XCTAssertNil(responseError, "function should not return errors")
        XCTAssertEqual(5, responseResult?.count, "No Matching record counts")
        XCTAssertEqual("London, City of London, United Kingdom", responseResult?.first?.description, "No Matching Details of result")

        let recordLocalities = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .localities
        })
        XCTAssertNotNil(recordLocalities, "As per config localities record should be fetch")

        let recordStore = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .store
        })
        XCTAssertNil(recordStore, "As per config store record should not be fetch")

        let recordAddress = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .address
        })
        XCTAssertNil(recordAddress, "As per config address record should not be fetch")

        let recordPlace = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .places
        })
        XCTAssertNil(recordPlace, "As per config address record should not be fetch")

    }

    func testautocomplete_Row35() throws {
        // given
        let testObject = MultiSearch.init(debounceTime: 100)
        let localitiesProvider: ProviderConfig = ProviderConfig(searchType: .localities,
                                                                key: FakeTestData.woosmapKey,
                                                                minInputLength: 3,
                                                                param: ConfigParam(components: Components(country: ["fr", "gb"]),
                                                                                   types: ["locality", "postal_code"],
                                                                                   language: "en"))
        let addressProvider: ProviderConfig = ProviderConfig(searchType: .address,
                                                             key: FakeTestData.woosmapKey,
                                                             minInputLength: 5,
                                                             param: ConfigParam(components: Components(country: ["fr"]),
                                                                                language: "fr"))

        let placesProvider: ProviderConfig = ProviderConfig(searchType: .places,
                                                            key: FakeTestData.placesKey,
                                                            minInputLength: 2,
                                                            param: ConfigParam(components: Components(country: ["fr"]), language: "fr"))

        testObject.addProvider(config: localitiesProvider)
        testObject.addProvider(config: addressProvider)
        testObject.addProvider(config: placesProvider)

        var responseError: WoosmapError?
        var responseResult: [AutocompleteResponseItem]?

        let promise = expectation(description: "Should return result")
        // when
        testObject.autocompleteMulti(input: "Man") { (result, error) in
            responseResult = result
            responseError = error
            promise.fulfill()
        }

        wait(for: [promise], timeout: 5)

        // then
        XCTAssertNil(responseError, "function should not return errors")
        XCTAssertEqual(5, responseResult?.count, "No Matching record counts")
        XCTAssertEqual("Mandelieu-la-Napoule, Alpes-Maritimes, France", responseResult?.first?.description, "No Matching Details of result")

        let recordLocalities = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .localities
        })
        XCTAssertNotNil(recordLocalities, "As per config localities record should be fetch")

        let recordStore = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .store
        })
        XCTAssertNil(recordStore, "As per config store record should not be fetch")

        let recordAddress = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .address
        })
        XCTAssertNil(recordAddress, "As per config address record should not be fetch")

        let recordPlace = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .places
        })
        XCTAssertNil(recordPlace, "As per config address record should not be fetch")

    }

    func testautocomplete_Row38() throws {
        // given
        let testObject = MultiSearch.init(debounceTime: 100)
        let localitiesProvider: ProviderConfig = ProviderConfig(searchType: .localities,
                                                                key: FakeTestData.woosmapKey,
                                                                minInputLength: 3,
                                                                param: ConfigParam(components: Components(country: ["it"]),
                                                                                   types: ["locality", "postal_code"],
                                                                                   language: "en"))
        let addressProvider: ProviderConfig = ProviderConfig(searchType: .address,
                                                             key: FakeTestData.woosmapKey,
                                                             minInputLength: 5,
                                                             param: ConfigParam(components: Components(country: ["it"]),
                                                                                language: "it"))

        let placesProvider: ProviderConfig = ProviderConfig(searchType: .places,
                                                            key: FakeTestData.placesKey,
                                                            minInputLength: 2,
                                                            param: ConfigParam(components: Components(country: ["fr"]), language: "fr"))

        testObject.addProvider(config: localitiesProvider)
        testObject.addProvider(config: addressProvider)
        testObject.addProvider(config: placesProvider)

        var responseError: WoosmapError?
        var responseResult: [AutocompleteResponseItem]?

        let promise = expectation(description: "Should return result")
        // when
        testObject.autocompleteMulti(input: "Via dom") { (result, error) in
            responseResult = result
            responseError = error
            promise.fulfill()
        }

        wait(for: [promise], timeout: 5)

        // then
        XCTAssertNil(responseError, "function should not return errors")
        XCTAssertEqual(5, responseResult?.count, "No Matching record counts")
        XCTAssertEqual("Via Domenichino, 20149 Milano MI, Italia", responseResult?.first?.description, "No Matching Details of result")

        let recordLocalities = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .localities
        })
        XCTAssertNil(recordLocalities, "As per config localities record should not be fetch")

        let recordStore = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .store
        })
        XCTAssertNil(recordStore, "As per config store record should not be fetch")

        let recordAddress = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .address
        })
        XCTAssertNotNil(recordAddress, "As per config address record should be fetch")

        let recordPlace = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .places
        })
        XCTAssertNil(recordPlace, "As per config address record should not be fetch")

    }

    func testautocomplete_Row39() throws {
        // given
        let testObject = MultiSearch.init(debounceTime: 100)
        let localitiesProvider: ProviderConfig = ProviderConfig(searchType: .localities,
                                                                key: FakeTestData.woosmapKey,
                                                                minInputLength: 3,
                                                                param: ConfigParam(components: Components(country: ["it"]),
                                                                                   types: ["locality", "postal_code"],
                                                                                   language: "en"))
        let addressProvider: ProviderConfig = ProviderConfig(searchType: .address,
                                                             key: FakeTestData.woosmapKey,
                                                             minInputLength: 5,
                                                             param: ConfigParam(components: Components(country: ["it"]),
                                                                                language: "it"))

        let placesProvider: ProviderConfig = ProviderConfig(searchType: .places,
                                                            key: FakeTestData.placesKey,
                                                            minInputLength: 2,
                                                            param: ConfigParam(components: Components(country: ["fr"]), language: "fr"))

        testObject.addProvider(config: localitiesProvider)
        testObject.addProvider(config: addressProvider)
        testObject.addProvider(config: placesProvider)

        var responseError: WoosmapError?
        var responseResult: [AutocompleteResponseItem]?

        let promise = expectation(description: "Should return result")
        // when
        testObject.autocompleteMulti(input: "Tardini") { (result, error) in
            responseResult = result
            responseError = error
            promise.fulfill()
        }

        wait(for: [promise], timeout: 5)

        // then
        XCTAssertNil(responseError, "function should not return errors")
        XCTAssertEqual(1, responseResult?.count, "No Matching record counts")
        XCTAssertEqual("Via Domenico Tardini, 00167 Roma RM, Italia", responseResult?.first?.description, "No Matching Details of result")

        let recordLocalities = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .localities
        })
        XCTAssertNil(recordLocalities, "As per config localities record should not be fetch")

        let recordStore = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .store
        })
        XCTAssertNil(recordStore, "As per config store record should not be fetch")

        let recordAddress = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .address
        })
        XCTAssertNotNil(recordAddress, "As per config address record should be fetch")

        let recordPlace = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .places
        })
        XCTAssertNil(recordPlace, "As per config address record should not be fetch")

    }

    func testautocomplete_Row42() throws {
        // given
        let testObject = MultiSearch.init(debounceTime: 100)
        let localitiesProvider: ProviderConfig = ProviderConfig(searchType: .localities,
                                                                key: FakeTestData.woosmapKey,
                                                                minInputLength: 3,
                                                                param: ConfigParam(components: Components(country: ["it"]),
                                                                                   types: ["locality", "postal_code"],
                                                                                   language: "en"))
        let addressProvider: ProviderConfig = ProviderConfig(searchType: .address,
                                                             key: FakeTestData.woosmapKey,
                                                             minInputLength: 5,
                                                             param: ConfigParam(components: Components(country: ["it"]),
                                                                                language: "fr"))

        let placesProvider: ProviderConfig = ProviderConfig(searchType: .places,
                                                            key: FakeTestData.placesKey,
                                                            minInputLength: 2,
                                                            param: ConfigParam(components: Components(country: ["fr"]), language: "fr"))

        testObject.addProvider(config: localitiesProvider)
        testObject.addProvider(config: addressProvider)
        testObject.addProvider(config: placesProvider)

        var responseError: WoosmapError?
        var responseResult: [AutocompleteResponseItem]?

        let promise = expectation(description: "Should return result")
        // when
        testObject.autocompleteMulti(input: "Via dom") { (result, error) in
            responseResult = result
            responseError = error
            promise.fulfill()
        }

        wait(for: [promise], timeout: 5)

        // then
        XCTAssertNil(responseError, "function should not return errors")
        XCTAssertEqual(5, responseResult?.count, "No Matching record counts")
        XCTAssertEqual("Via Domitiana, 80078 Pouzzoles NA, Italie", responseResult?.first?.description, "No Matching Details of result")

        let recordLocalities = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .localities
        })
        XCTAssertNil(recordLocalities, "As per config localities record should not be fetch")

        let recordStore = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .store
        })
        XCTAssertNil(recordStore, "As per config store record should not be fetch")

        let recordAddress = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .address
        })
        XCTAssertNotNil(recordAddress, "As per config address record should be fetch")

        let recordPlace = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .places
        })
        XCTAssertNil(recordPlace, "As per config address record should not be fetch")

    }

    func testautocomplete_Row43() throws {
        // given
        let testObject = MultiSearch.init(debounceTime: 100)
        let localitiesProvider: ProviderConfig = ProviderConfig(searchType: .localities,
                                                                key: FakeTestData.woosmapKey,
                                                                minInputLength: 3,
                                                                param: ConfigParam(components: Components(country: ["it"]),
                                                                                   types: ["locality", "postal_code"],
                                                                                   language: "en"))
        let addressProvider: ProviderConfig = ProviderConfig(searchType: .address,
                                                             key: FakeTestData.woosmapKey,
                                                             minInputLength: 5,
                                                             param: ConfigParam(components: Components(country: ["it"]),
                                                                                language: "fr"))

        let placesProvider: ProviderConfig = ProviderConfig(searchType: .places,
                                                            key: FakeTestData.placesKey,
                                                            minInputLength: 2,
                                                            param: ConfigParam(components: Components(country: ["fr"]), language: "fr"))

        testObject.addProvider(config: localitiesProvider)
        testObject.addProvider(config: addressProvider)
        testObject.addProvider(config: placesProvider)

        var responseError: WoosmapError?
        var responseResult: [AutocompleteResponseItem]?

        let promise = expectation(description: "Should return result")
        // when
        testObject.autocompleteMulti(input: "Tardini") { (result, error) in
            responseResult = result
            responseError = error
            promise.fulfill()
        }

        wait(for: [promise], timeout: 5)

        // then
        XCTAssertNil(responseError, "function should not return errors")
        XCTAssertEqual(1, responseResult?.count, "No Matching record counts")
        XCTAssertEqual("Via Domenico Tardini, 00167 Rome RM, Italie", responseResult?.first?.description, "No Matching Details of result")

        let recordLocalities = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .localities
        })
        XCTAssertNil(recordLocalities, "As per config localities record should not be fetch")

        let recordStore = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .store
        })
        XCTAssertNil(recordStore, "As per config store record should not be fetch")

        let recordAddress = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .address
        })
        XCTAssertNotNil(recordAddress, "As per config address record should be fetch")

        let recordPlace = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .places
        })
        XCTAssertNil(recordPlace, "As per config address record should not be fetch")

    }

    func testautocomplete_Row46() throws {
        // given
        let testObject = MultiSearch.init(debounceTime: 100)

        let placesProvider: ProviderConfig = ProviderConfig(searchType: .places,
                                                            key: FakeTestData.placesKey,
                                                            minInputLength: 2,
                                                            param: ConfigParam(components: Components(country: ["fr", "gb"]), language: "en"))

        testObject.addProvider(config: placesProvider)

        var responseError: WoosmapError?
        var responseResult: [AutocompleteResponseItem]?

        let promise = expectation(description: "Should return result")
        // when
        testObject.autocompleteMulti(input: "li") { (result, error) in
            responseResult = result
            responseError = error
            promise.fulfill()
        }

        wait(for: [promise], timeout: 5)

        // then
        XCTAssertNil(responseError, "function should not return errors")
        XCTAssertEqual(5, responseResult?.count, "No Matching record counts")
        XCTAssertEqual("Liverpool Street Station, London, UK", responseResult?.first?.description, "No Matching Details of result")

        let recordLocalities = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .localities
        })
        XCTAssertNil(recordLocalities, "As per config localities record should not be fetch")

        let recordStore = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .store
        })
        XCTAssertNil(recordStore, "As per config store record should not be fetch")

        let recordAddress = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .address
        })
        XCTAssertNil(recordAddress, "As per config address record should not be fetch")

        let recordPlace = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .places
        })
        XCTAssertNotNil(recordPlace, "As per config address record should be fetch")

    }

    func testautocomplete_Row47() throws {
        // given
        let testObject = MultiSearch.init(debounceTime: 100)

        let placesProvider: ProviderConfig = ProviderConfig(searchType: .places,
                                                            key: FakeTestData.placesKey,
                                                            minInputLength: 2,
                                                            param: ConfigParam(components: Components(country: ["fr", "gb"]), language: "en"))

        testObject.addProvider(config: placesProvider)

        var responseError: WoosmapError?
        var responseResult: [AutocompleteResponseItem]?

        let promise = expectation(description: "Should return result")
        // when
        testObject.autocompleteMulti(input: "Zara") { (result, error) in
            responseResult = result
            responseError = error
            promise.fulfill()
        }

        wait(for: [promise], timeout: 5)

        // then
        XCTAssertNil(responseError, "function should not return errors")
        XCTAssertEqual(5, responseResult?.count, "No Matching record counts")
        XCTAssertEqual("Zara - Oxford Street, Oxford Street, London, UK", responseResult?.first?.description, "No Matching Details of result")

        let recordLocalities = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .localities
        })
        XCTAssertNil(recordLocalities, "As per config localities record should not be fetch")

        let recordStore = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .store
        })
        XCTAssertNil(recordStore, "As per config store record should not be fetch")

        let recordAddress = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .address
        })
        XCTAssertNil(recordAddress, "As per config address record should not be fetch")

        let recordPlace = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .places
        })
        XCTAssertNotNil(recordPlace, "As per config address record should be fetch")

    }

    func testautocomplete_Row50() throws {
        // given
        let testObject = MultiSearch.init(debounceTime: 100)

        let storeProvider: ProviderConfig = ProviderConfig(searchType: .store,
                                                            key: FakeTestData.woosmapKey,
                                                            ignoreFallbackBreakpoint: true,
                                                            param: ConfigParam(query: "type:type1"))

        testObject.addProvider(config: storeProvider)

        var responseError: WoosmapError?
        var responseResult: [AutocompleteResponseItem]?

        let promise = expectation(description: "Should return result")
        // when
        testObject.autocompleteMulti(input: "vis") { (result, error) in
            responseResult = result
            responseError = error
            promise.fulfill()
        }

        wait(for: [promise], timeout: 5)

        // then
        XCTAssertNil(responseError, "function should not return errors")
        XCTAssertEqual(1, responseResult?.count, "No Matching record counts")
        XCTAssertEqual("Vista & Foothill, Vista", responseResult?.first?.description, "No Matching Details of result")

        let recordLocalities = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .localities
        })
        XCTAssertNil(recordLocalities, "As per config localities record should not be fetch")

        let recordStore = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .store
        })
        XCTAssertNotNil(recordStore, "As per config store record should be fetch")

        let recordAddress = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .address
        })
        XCTAssertNil(recordAddress, "As per config address record should not be fetch")

        let recordPlace = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .places
        })
        XCTAssertNil(recordPlace, "As per config address record should not be fetch")

    }


    func testautocomplete_Row53() throws {
        // given
        let testObject = MultiSearch.init(debounceTime: 100)

        let localitiesProvider: ProviderConfig = ProviderConfig(searchType: .localities,
                                                            key: FakeTestData.woosmapKey,
                                                            minInputLength: 3,
                                                            param: ConfigParam(components: Components(country: ["cn"]),
                                                                               types: ["locality", "postal_code"],
                                                                               language: "en"))
        let placesProvider: ProviderConfig = ProviderConfig(searchType: .places,
                                                            key: FakeTestData.placesKey,
                                                            minInputLength: 3,
                                                            param: ConfigParam(components: Components(country: ["cn"]), language: "en"))

        testObject.addProvider(config: localitiesProvider)
        testObject.addProvider(config: placesProvider)

        var responseError: WoosmapError?
        var responseResult: [AutocompleteResponseItem]?

        let promise = expectation(description: "Should return result")
        // when
        testObject.autocompleteMulti(input: "北京市") { (result, error) in
            responseResult = result
            responseError = error
            promise.fulfill()
        }

        wait(for: [promise], timeout: 5)

        // then
        XCTAssertNil(responseError, "function should not return errors")
        XCTAssertEqual(2, responseResult?.count, "No Matching record counts")
        XCTAssertEqual("Beijing, 北京市, China", responseResult?.first?.description, "No Matching Details of result")

        let recordLocalities = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .localities
        })
        XCTAssertNotNil(recordLocalities, "As per config localities record should be fetch")

        let recordStore = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .store
        })
        XCTAssertNil(recordStore, "As per config store record should not be fetch")

        let recordAddress = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .address
        })
        XCTAssertNil(recordAddress, "As per config address record should not be fetch")

        let recordPlace = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .places
        })
        XCTAssertNil(recordPlace, "As per config address record should not be fetch")
    }

    func testautocomplete_Row56() throws {
        // given
        let testObject = MultiSearch.init(debounceTime: 100)

        let localitiesProvider: ProviderConfig = ProviderConfig(searchType: .localities,
                                                            key: FakeTestData.woosmapKey,
                                                            minInputLength: 3,
                                                            param: ConfigParam(components: Components(country: ["qa"]),
                                                                               types: ["locality", "postal_code"],
                                                                               language: "ar"))
        let placesProvider: ProviderConfig = ProviderConfig(searchType: .places,
                                                            key: FakeTestData.placesKey,
                                                            minInputLength: 3,
                                                            param: ConfigParam(components: Components(country: ["qa"]), language: "ar"))

        testObject.addProvider(config: localitiesProvider)
        testObject.addProvider(config: placesProvider)

        var responseError: WoosmapError?
        var responseResult: [AutocompleteResponseItem]?

        let promise = expectation(description: "Should return result")
        // when
        testObject.autocompleteMulti(input: "الدوحة") { (result, error) in
            responseResult = result
            responseError = error
            promise.fulfill()
        }

        wait(for: [promise], timeout: 5)

        // then
        XCTAssertNil(responseError, "function should not return errors")
        XCTAssertEqual(5, responseResult?.count, "No Matching record counts")
        XCTAssertEqual("الدوحة, فريج محمد بن جاسم / مشيرب, Qatar", responseResult?.first?.description, "No Matching Details of result")

        let recordLocalities = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .localities
        })
        XCTAssertNotNil(recordLocalities, "As per config localities record should be fetch")

        let recordStore = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .store
        })
        XCTAssertNil(recordStore, "As per config store record should not be fetch")

        let recordAddress = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .address
        })
        XCTAssertNil(recordAddress, "As per config address record should not be fetch")

        let recordPlace = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .places
        })
        XCTAssertNil(recordPlace, "As per config address record should not be fetch")
    }
    func testautocomplete_Row59() throws {
        // given
        let testObject = MultiSearch.init(debounceTime: 100)

        let localitiesProvider: ProviderConfig = ProviderConfig(searchType: .localities,
                                                            key: FakeTestData.woosmapKey,
                                                            fallbackBreakpoint: 1,
                                                            minInputLength: 1,
                                                            param: ConfigParam(components: Components(country: ["in"]),
                                                                               types: ["postal_code"],
                                                                               data: .advanced)
                                                            )
        testObject.addProvider(config: localitiesProvider)

        var responseError: WoosmapError?
        var responseResult: [AutocompleteResponseItem]?

        let promise = expectation(description: "Should return result")
        // when
        testObject.autocompleteMulti(input: "365601") { (result, error) in
            responseResult = result
            responseError = error
            promise.fulfill()
        }

        wait(for: [promise], timeout: 5)

        // then
        XCTAssertNil(responseError, "function should not return errors")
        XCTAssertEqual(2, responseResult?.count, "No Matching record counts")
        XCTAssertEqual("365601, Amreli, India", responseResult?.first?.description, "No Matching Details of result")

        let recordLocalities = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .localities
        })
        XCTAssertNotNil(recordLocalities, "As per config localities record should be fetch")
    }
    func testautocomplete_Row60() throws {
        // given
        let testObject = MultiSearch.init(debounceTime: 100)

        let localitiesProvider: ProviderConfig = ProviderConfig(searchType: .localities,
                                                            key: FakeTestData.woosmapKey,
                                                            fallbackBreakpoint: 1,
                                                            minInputLength: 1,
                                                            param: ConfigParam(components: Components(country: ["in"]),
                                                                               types: ["postal_code"],
                                                                               data: .standard)
                                                            )
        testObject.addProvider(config: localitiesProvider)

        var responseError: WoosmapError?
        var responseResult: [AutocompleteResponseItem]?

        let promise = expectation(description: "Should return result")
        // when
        testObject.autocompleteMulti(input: "365601") { (result, error) in
            responseResult = result
            responseError = error
            promise.fulfill()
        }

        wait(for: [promise], timeout: 5)

        // then
        XCTAssertNil(responseError, "function should not return errors")
        XCTAssertEqual(0, responseResult?.count, "No Matching record counts")
    }
    func testautocomplete_Row62() throws {
        // given
        let testObject = MultiSearch.init(debounceTime: 100)

        let localitiesProvider: ProviderConfig = ProviderConfig(searchType: .localities,
                                                            key: FakeTestData.woosmapKey,
                                                            fallbackBreakpoint: 1,
                                                            minInputLength: 1,
                                                            param: ConfigParam(components: Components(country: ["fr"]),
                                                                               types: ["locality"],
                                                                               extended: "postal_code")
                                                            )
        testObject.addProvider(config: localitiesProvider)

        var responseError: WoosmapError?
        var responseResult: [AutocompleteResponseItem]?

        let promise = expectation(description: "Should return result")
        // when
        testObject.autocompleteMulti(input: "60160") { (result, error) in
            responseResult = result
            responseError = error
            promise.fulfill()
        }

        wait(for: [promise], timeout: 5)

        // then
        XCTAssertNil(responseError, "function should not return errors")
        XCTAssertEqual(5, responseResult?.count, "No Matching record counts")
        XCTAssertEqual("Montataire (60160), Oise, France", responseResult?.first?.description, "No Matching Details of result")

        let recordLocalities = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .localities
        })
        XCTAssertNotNil(recordLocalities, "As per config localities record should be fetch")
    }
    func testautocomplete_Row63() throws {
        // given
        let testObject = MultiSearch.init(debounceTime: 100)

        let localitiesProvider: ProviderConfig = ProviderConfig(searchType: .localities,
                                                            key: FakeTestData.woosmapKey,
                                                            fallbackBreakpoint: 1,
                                                            minInputLength: 1,
                                                            param: ConfigParam(components: Components(country: ["fr"]),
                                                                               types: ["locality"])
                                                            )
        testObject.addProvider(config: localitiesProvider)

        var responseError: WoosmapError?
        var responseResult: [AutocompleteResponseItem]?

        let promise = expectation(description: "Should return result")
        // when
        testObject.autocompleteMulti(input: "60160") { (result, error) in
            responseResult = result
            responseError = error
            promise.fulfill()
        }

        wait(for: [promise], timeout: 5)

        // then
        XCTAssertNil(responseError, "function should not return errors")
        XCTAssertEqual(0, responseResult?.count, "No Matching record counts")
    }
    func testautocomplete_trelloIssue1() throws {
        // given
        let testObject = MultiSearch.init(debounceTime: 100)

        let localitiesProvider: ProviderConfig = ProviderConfig(searchType: .localities,
                                                            key: FakeTestData.woosmapKey,
                                                            fallbackBreakpoint: 0.5,
                                                            minInputLength: 5)
        let placesProvider: ProviderConfig = ProviderConfig(searchType: .places,
                                                            key: FakeTestData.placesKey,
                                                            ignoreFallbackBreakpoint: true,
                                                            minInputLength: 1)

        testObject.addProvider(config: localitiesProvider)
        testObject.addProvider(config: placesProvider)

        var responseError: WoosmapError?
        var responseResult: [AutocompleteResponseItem]?

        let promise = expectation(description: "Should return result")
        // when
        testObject.autocompleteMulti(input: "pa") { (result, error) in
            responseResult = result
            responseError = error
            promise.fulfill()
        }

        wait(for: [promise], timeout: 5)

        // then
        XCTAssertNil(responseError, "function should not return errors")
        XCTAssertEqual(5, responseResult?.count, "No Matching record counts")
        XCTAssertEqual("Paris, France", responseResult?.first?.description, "No Matching Details of result")

        let recordLocalities = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .localities
        })
        XCTAssertNil(recordLocalities, "As per config localities record should not be fetch")

        let recordStore = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .store
        })
        XCTAssertNil(recordStore, "As per config store record should not be fetch")

        let recordAddress = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .address
        })
        XCTAssertNil(recordAddress, "As per config address record should not be fetch")

        let recordPlace = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .places
        })
        XCTAssertNotNil(recordPlace, "As per config places record should be fetch")
    }
    func testautocomplete_trelloIssue1_1() throws {
        // given
        let testObject = MultiSearch.init(debounceTime: 100)

        let localitiesProvider: ProviderConfig = ProviderConfig(searchType: .localities,
                                                            key: FakeTestData.woosmapKey,
                                                            fallbackBreakpoint: 0.5,
                                                            minInputLength: 5)
        let placesProvider: ProviderConfig = ProviderConfig(searchType: .places,
                                                            key: FakeTestData.placesKey,
                                                            fallbackBreakpoint: 1.0,
                                                            minInputLength: 1)

        testObject.addProvider(config: localitiesProvider)
        testObject.addProvider(config: placesProvider)

        var responseError: WoosmapError?
        var responseResult: [AutocompleteResponseItem]?

        let promise = expectation(description: "Should return result")
        // when
        testObject.autocompleteMulti(input: "pa") { (result, error) in
            responseResult = result
            responseError = error
            promise.fulfill()
        }

        wait(for: [promise], timeout: 5)

        // then
        XCTAssertNil(responseError, "function should not return errors")
        XCTAssertEqual(0, responseResult?.count, "No Matching record counts")
    }
}
