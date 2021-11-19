//
//  MultiSearch_Index.swift
//  MultisearchTests
//
//  Created by apple on 27/04/21.
//

import XCTest
@testable import Multisearch

class Multisearch_IndexTests: XCTestCase {
    var testObject: MultiSearch!
    var localitiesProvider: ProviderConfig!
    var addressProvider: ProviderConfig!
    var storeProvider: ProviderConfig!
    var placesProvider: ProviderConfig!

    // let networkMonitor = NetworkMoniter.shared

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        testObject = MultiSearch.init(debounceTime: 0)
        localitiesProvider = ProviderConfig(searchType: .localities,
                                            key: FakeTestData.woosmapKey,
                                                 fallbackBreakpoint: 0.7,
                                                 minInputLength: 1,
                                                 param: ConfigParam(
                                                    components: Components(country: ["FR"]),
                                                    types: ["locality", "country", "postal_code"]))

        addressProvider = ProviderConfig(searchType: .address,
                                              key: FakeTestData.woosmapKey,
                                              fallbackBreakpoint: 0.8,
                                              minInputLength: 1,
                                              param: ConfigParam(components: Components(country: ["IT"]),
                                                language: "it"))

        storeProvider = ProviderConfig(searchType: .store,
                                            key: FakeTestData.woosmapKey,
                                            fallbackBreakpoint: 0,
                                            param: ConfigParam(query: "type:type1"))

        placesProvider = ProviderConfig(searchType: .places,
                                             key: FakeTestData.placesKey,
                                             fallbackBreakpoint: 0.7,
                                             minInputLength: 1,
                                             param: ConfigParam.init(
                                                components: Components(country: ["FR"])))
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.

    }

    // MARK: - Search test
    func testAutocomplete_localities() throws {
        // given
        testObject.addProvider(config: localitiesProvider)
        var responseError: WoosmapError?
        var responseResult: [AutocompleteResponseItem]?

        let promise = expectation(description: "Should return result ")
        // when
        testObject.autocompleteLocalities(input: "paris") { (result, error) in
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

    func testAutocomplete_places() throws {
        // given
        testObject.addProvider(config: placesProvider)
        var responseError: WoosmapError?
        var responseResult: [AutocompleteResponseItem]?

        let promise = expectation(description: "Should return result ")
        // when
        testObject.autocompletePlaces(input: "paris") { (result, error) in
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

    func testAutocomplete_address() throws {
        // given
        testObject.addProvider(config: addressProvider)
        var responseError: WoosmapError?
        var responseResult: [AutocompleteResponseItem]?

        let promise = expectation(description: "Should return result ")
        // when
        testObject.autocompleteAddress(input: "paris") { (result, error) in
            responseResult = result
            responseError = error
            promise.fulfill()
        }

        wait(for: [promise], timeout: 5)

        // then
        XCTAssertNil(responseError, "error")
        XCTAssertEqual(3, responseResult?.count, "Matching record counts")
        XCTAssertEqual("Parise, Burolo, Piemonte, Italia", responseResult?.first?.description, "Matching Details of result")
        responseResult?.forEach({ (response) in
            XCTAssertNotNil(response.matchedSubstrings)
        })
    }

    func testAutocomplete_store() throws {
        // given
        testObject.addProvider(config: storeProvider)
        var responseError: WoosmapError?
        var responseResult: [AutocompleteResponseItem]?

        let promise = expectation(description: "Should return result ")
        // when
        testObject.autocompleteStore(input: "vista") { (result, error) in
            responseResult = result
            responseError = error
            promise.fulfill()
        }

        wait(for: [promise], timeout: 5)

        // then
        XCTAssertNil(responseError, "error")
        XCTAssertEqual(1, responseResult?.count, "Matching record counts")
        XCTAssertEqual("Vista & Foothill, Vista", responseResult?.first?.description, "Matching Details of result")
    }

    // MARK: - Detail test
    func testDetail_localities() throws {
        // given
        testObject.addProvider(config: localitiesProvider)
        var responseError: WoosmapError?
        var responseResult: DetailsResponseItem?

        let promise = expectation(description: "Should return result ")
        // when
        testObject.details(id: "69r+o9VWkKkuWNWdQSBY96oQvTk=", provider: .localities) { (result, error) in
            responseResult = result
            responseError = error
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)

        // then
        XCTAssertNil(responseError)
        XCTAssertEqual("Wigan Road Farm, Wigan Road, Golborne, Warrington, WA3 3UF", responseResult?.formattedAddress)
        XCTAssertNotNil(responseResult?.addressComponents, "Address component is missing")
    }
    func testDetail_localities1() throws {
        // given
        testObject.addProvider(config: localitiesProvider)
        var responseError: WoosmapError?
        var responseResult: DetailsResponseItem?

        let promise = expectation(description: "Should return result ")
        // when
        testObject.details(id: "vWA87ZwgR3V1RMRpY0QXZEGQoFk=", provider: .localities) { (result, error) in
            responseResult = result
            responseError = error
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)

        // then
        XCTAssertNil(responseError)
        XCTAssertEqual("Montpellier, Hérault", responseResult?.formattedAddress)
        XCTAssertNotNil(responseResult?.addressComponents, "Address component is missing")
    }
    func testDetail_localities_notFound() throws {
        // given
        testObject.addProvider(config: localitiesProvider)
        var responseError: WoosmapError?
        var responseResult: DetailsResponseItem?

        let promise = expectation(description: "Should return result ")
        // when
        testObject.details(id: "tZJ25ZbtBPSiSxYUyQPJd", provider: .localities) { (result, error) in
            responseResult = result
            responseError = error
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)

        // then
        XCTAssertNotNil(responseError, "function should return errors")
        XCTAssertNil(responseResult, "function should not return result")

    }

    func testDetail_address() throws {
        // given
        testObject.addProvider(config: addressProvider)
        var responseError: WoosmapError?
        var responseResult: DetailsResponseItem?

        let promise = expectation(description: "Should return result ")
        // when
        testObject.details(id: "aGVyZTphZjpzdHJlZXQ6WVlhYnBWdEtON3RnSmx2YzlOdEZ0Qw==", provider: .address) { (result, error) in
            responseResult = result
            responseError = error
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)

        // then
        XCTAssertNil(responseError)
        XCTAssertEqual("Via Domitiana, 80078 Pozzuoli NA, Italia", responseResult?.formattedAddress)
        XCTAssertNotNil(responseResult?.addressComponents, "Address component is missing")
    }

    func testDetail_address_notfound() throws {
        // given
        testObject.addProvider(config: addressProvider)
        var responseError: WoosmapError?
        var responseResult: DetailsResponseItem?

        let promise = expectation(description: "Should return result ")
        // when
        testObject.details(id: "UGFyaXMsIMOObGUtZ=", provider: .address) { (result, error) in
            responseResult = result
            responseError = error
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)

        // then
        XCTAssertNotNil(responseError, "function should return errors")
        XCTAssertNil(responseResult, "function should not return result")
    }
    func testDetail_store() throws {
        // given
        testObject.addProvider(config: storeProvider)
        var responseError: WoosmapError?
        var responseResult: DetailsResponseItem?

        let promise = expectation(description: "Should return result ")
        // when
        testObject.details(id: "10008_98261", provider: .store) { (result, error) in
            responseResult = result
            responseError = error
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)

        // then
        XCTAssertNil(responseError)
        XCTAssertEqual("1385 East Vista Way", responseResult?.formattedAddress)
        XCTAssertEqual(.store, responseResult?.api)
        XCTAssertNotNil(responseResult?.addressComponents, "Address component is missing")
    }

    func testDetail_store_notfound() throws {
        // given
        testObject.addProvider(config: storeProvider)
        var responseError: WoosmapError?
        var responseResult: DetailsResponseItem?

        let promise = expectation(description: "Should return result ")
        // when
        testObject.details(id: "UGFyaXMsIMOObGUtZ=", provider: .store) { (result, error) in
            responseResult = result
            responseError = error
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)

        // then
        XCTAssertNotNil(responseError, "function should return errors")
        XCTAssertNil(responseResult, "function should not return result")
    }
    func testDetail_place() throws {
        // given
        testObject.addProvider(config: placesProvider)
        var responseError: WoosmapError?
        var responseResult: DetailsResponseItem?

        let promise = expectation(description: "Should return result ")
        // when
        testObject.details(id: "ChIJEW4ls3nVwkcRYGNkgT7xCgQ", provider: .places) { (result, error) in
            responseResult = result
            responseError = error
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)

        // then
        XCTAssertNil(responseError, "function should return errors")
        XCTAssertEqual("Lille, France", responseResult?.formattedAddress, "Address not matctch with expected")
        XCTAssertNotNil(responseResult?.addressComponents, "Address component is missing")
    }

    func testDetail_place_notfound() throws {
        // given
        testObject.addProvider(config: placesProvider)
        var responseError: WoosmapError?
        var responseResult: DetailsResponseItem?

        let promise = expectation(description: "Should return result ")
        // when
        testObject.details(id: "UGFyaXMsIMOObGUtZ=", provider: .places) { (result, error) in
            responseResult = result
            responseError = error
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)

        // then
        XCTAssertNotNil(responseError, "function should return errors")
        XCTAssertNil(responseResult, "function should not return result")
    }

    func testautocompleteMulti() throws {
        // given
        testObject.addProvider(config: ProviderConfig(searchType: .localities, key: FakeTestData.woosmapKey, fallbackBreakpoint: 0.5))
        testObject.addProvider(config: ProviderConfig(searchType: .address, key: FakeTestData.woosmapKey, fallbackBreakpoint: 0.5))
        testObject.addProvider(config: ProviderConfig(searchType: .store, key: FakeTestData.woosmapKey, ignoreFallbackBreakpoint: true))
        var responseError: WoosmapError?
        var responseResult: [AutocompleteResponseItem]?

        let promise = expectation(description: "Should return result")
        // when
        testObject.autocompleteMulti(input: "po") { (result, error) in
            responseResult = result
            responseError = error
            promise.fulfill()
        }

        wait(for: [promise], timeout: 5)

        // then
        XCTAssertNil(responseError, "function should not return errors")
        XCTAssertEqual(10, responseResult?.count, "No Matching record counts")
        XCTAssertEqual("Pó, Leiria, Portugal", responseResult?.first?.description, "No Matching Details of result")

        let recordLocalities = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .localities
        })
        XCTAssertNotNil(recordLocalities, "As per config localities record should be fetch")

        let recordStore = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .store
        })
        XCTAssertNotNil(recordStore, "As per config store record should be fetch")

        let recordAddress = responseResult?.firstIndex(where: { (item) -> Bool in
            return item.api == .address
        })
        XCTAssertNil(recordAddress, "As per config address record should not fetch")

    }

}
