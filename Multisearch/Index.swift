//
//  WoosmapMultisearch.swift
//  Multisearch
//
//  Created by apple on 19/04/21.
//

import Foundation
/**
 Woosmap Search
 */
public class MultiSearch {

    public typealias SearchCompletionHandler = (_ userResponse: [AutocompleteResponseItem]?,
                                                _ error: WoosmapError?) -> Void

    public typealias DetailCompletionHandler = (_ result: DetailsResponseItem?,
                                                _ error: WoosmapError?) -> Void

    /// Session id
    var searchSessionID: String = UUID.init().uuidString

    /// The amount of time in (seconds) the function will wait after the last received call before executing the next one.
    var debounceTime: Int = 0

    /// List of configuration providers
    var providerConfig: [ProviderConfig] = []

    /// Last searched string
    var searchingString: String?

    /// Callback function. Returns back result to the calling function
    var searchingHandler: SearchCompletionHandler?

    /// Handle debouncing functionallity
    var debouncer: Debouncer?

    /// Store last executed search string
    private var lastInput: String?

    /// Store last executed search string
    private var lastAPICall: SearchProviderType?
    /**
     Create an instance for Woosmap search
     
     - Parameter debounceTime: Snooze time for repeated search
     */
    public init (debounceTime: Int ) {
        self.debounceTime = debounceTime
        if debounceTime>0 {
            self.debouncer = Debouncer(timeInterval: TimeInterval(debounceTime / 1000)) // Convert into seconds
        }

    }

    /// Configure Api provider for search option
    ///
    /// This helps you to add new provider for multisearch sequence
    ///
    ///  Code
    ///  ----
    ///
    ///         let placesProvider = ProviderConfig(searchType: .places,
    ///                 key: "XXXXXXXXXXXXXXXXXXXXX_-XXXXXXX",
    ///                 fallbackBreakpoint: 0.7,
    ///                 minInputLength: 1,
    ///                 param: ConfigParam(
    ///                 components: Components.init(country: ["FR"])))
    ///         //Order for calling multisearch api
    ///         objSearch.addProvider(config: placesProvider)
    /// - Parameter config:configuration rules for each provider. Your result will be base of rules you
    /// - Warning: In case of duplicate configuration of same provider it will remove older one and add the latest one at end of search sequence
    /// - Throws:
    ///     Does not throw any error
    public func addProvider(config: ProviderConfig) {

        if let lastAddedProvider = providerConfig.firstIndex(where: { (item) -> Bool in
            return item.searchType == config.searchType
        }) {
            self.providerConfig.remove(at: lastAddedProvider)
        }
        self.providerConfig.append(config)
    }

    /// Remove specified provider from Multisearch
    ///
    /// In case the specified provider is not configured with Multisearch, this function will do nothing.
    /// - Parameter provider: Provider to be removed.
    public func removeProvider(provider: SearchProviderType) {
        if let lastAddedProvider = providerConfig.firstIndex(where: { (item) -> Bool in
            return item.searchType == provider
        }) {
            self.providerConfig.remove(at: lastAddedProvider)
        }
    }

    /// Searching  location address  in multiple available provider configure with multisearch
    ///
    /// Function return list of Locality info for given search string
    ///
    /// Code
    ///  ---
    ///
    ///         objSearch.autocompleteMulti(input: "st") { (result, error) in
    ///             if let callingError = error {
    ///                 print("failed to execute api \( callingError.localizedDescription ?? "-")")
    ///             } else {
    ///                 print("fetching result")
    ///                 print(result?.count ?? 0)
    ///                 result?.forEach({ (item) in
    ///                 print("===============")
    ///                 print(item.api)
    ///                 print(item.id ?? "")
    ///                 print(item.types ?? "")
    ///                 print(item.matched_substrings ?? "")
    ///                 print(item.description )
    ///                 print(item.score ?? 0 )
    ///                 print("===============")
    ///             })
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - input: String to be searched
    ///   - completionBlock: Callback function to return search result list or Error code
    /// - Returns: Query the different autocomplete APIs defined in order in it added.
    /// Depending on the **fallbackBreakpoint** and the **minInputLength** defined for each API,
    /// if the first API does not send relevant enough results, it will query the next one, until results are relevant or
    /// no other API is in the list.
    /// - Throws: Throwing error with return function in WoosmapError format
    ///     - Configuration missing
    ///     - Api provider failed

    public func autocompleteMulti(input: String,
                                  completionBlock: @escaping(SearchCompletionHandler)) {
        searchingString = input.cleanup()
        searchingHandler = completionBlock
        if debounceTime == 0 {
            autocompleteMultiHandler(completionBlock)
        } else {
            debouncer?.renewInterval()
            self.debouncer?.handler = {
                self.autocompleteMultiHandler(self.searchingHandler)
            }
        }
    }
    /// Capture Valid search provider using last search history
    ///
    /// When a provider doesn't provide satisfactory result, the sdk fallbacks to the next provider and doesn't request the previous one for next character. Only if some character are removed, sdk re-start with the first provider
    /// - Returns: list of provider
    private func multiSearchValidProvider() -> [ProviderConfig] {
        var validProvider: [ProviderConfig] = []
        if let lastApi = self.lastAPICall {
            if let executedApiIndex = providerConfig.firstIndex(where: { item in
                item.searchType == lastApi
            }) {
                providerConfig.forEach { providerItem in
                    if providerItem.ignoreFallbackBreakpoint == true {
                        validProvider.append(providerItem)
                    } else {
                        if let fallbackprovider = providerConfig.firstIndex(where: { fallbackConfig in
                            return fallbackConfig.searchType == providerItem.searchType
                        }) {
                            if fallbackprovider >= executedApiIndex {
                                validProvider.append(providerItem)
                            }
                        }
                    }
                }
            } else {
                validProvider = providerConfig
            }
        } else {
            validProvider = providerConfig
        }
        return validProvider
    }
    /// Checking last executed search input  to match with current one
    ///
    /// Handle for user modified search result by pressing backpress
    /// - Parameter input: current input for search address
    /// - Returns: check prefex for input and it matching with previous search then return true or false
    private func isNewInputIsContainedInLastInput(_ input: String) -> Bool {
        if (lastInput ?? "").hasPrefix(input) {
            return true
        }
        return false
    }
    /// This function gets called when debouncer is implemented for delay function call
    private func autocompleteMultiHandler(_ handler: SearchCompletionHandler?) {
        if let input = searchingString {
            if input == lastInput {
                return // Skip search as this result reander on screen previously
            }
            if isNewInputIsContainedInLastInput(input) {
                self.lastAPICall = nil
            }
            let validProvider: [ProviderConfig] = self.multiSearchValidProvider()
            let searchProvider: MultiProvider = MultiProvider(providers: validProvider)
            searchProvider.autocomplete(input: input ) { (result, error) in
                // print("Dispatching result for \(input)")
                if input == self.searchingString ?? "" { // Check search is not dirty
                    if let completionBlock = handler {
                        DispatchQueue.main.async {
                            if let callError = error {
                                self.lastInput = nil
                                completionBlock(nil, WoosmapError.Error(message: callError.localizedDescription, statusText: Constants.apiFailed, status: nil))
                            } else {
                                completionBlock(result, nil)
                                self.lastInput = input
                                if let result = result {
                                    // Get fallback provider
                                    self.lastAPICall = nil
                                    self.providerConfig.forEach { item in
                                        if item.ignoreFallbackBreakpoint == false {
                                            let resultFound = result.firstIndex { resultItem in
                                                return resultItem.api == item.searchType
                                            }
                                            if resultFound != nil {
                                                self.lastAPICall = item.searchType
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    /// Searching places with given provider
    /// - Parameters:
    ///   - provider: Type of provider used for search
    ///   - input: String to searched
    ///   - completionBlock: Return search results list or error code
    /// - Returns: List of Places matching with input
    private func autocomplete(provider: SearchProviderType, input: String, completionBlock: @escaping(SearchCompletionHandler)) {

        let searchAddress = input.cleanup()
        if lastInput == searchAddress {
            return // Skip search as this result reander on screen previously
        }

        let configItem  = providerConfig.first { (item) -> Bool in
            return item.searchType == provider
        }

        guard let config =  configItem else {
            return completionBlock(nil, WoosmapError.Error(message: "Configuration is missing", statusText: "Missing", status: nil))
        }

        if config.minInputLength <= searchAddress.length {
            var searchProvider: AbstractProvider
            switch provider {
            case .localities:
                searchProvider = LocalitiesProvider.init(config)
            case .places:
                searchProvider = PlacesProvider.init(config)
            case .address:
                searchProvider = AddressProvider.init(config)
            case .store:
                searchProvider = StoreProvider.init(config)
            }

            searchProvider.search(searchAddress) { (result, error) in
                DispatchQueue.main.async {
                    if let callError = error {
                        self.lastInput = nil
                        completionBlock(nil, WoosmapError.Error(message: callError.localizedDescription, statusText: callError.errorDescription, status: callError.status))
                    } else {
                        self.lastInput = searchAddress
                        completionBlock(result, nil)
                    }
                }
            }
        } else {
            self.lastInput = nil
            completionBlock([], nil) // Returns an empty array as input length criteria not fulfilled.
        }
    }

    /// Search location info with Address provider
    ///
    /// Function return list of locality info for given search string
    ///
    /// Code
    ///  ---
    ///
    ///         objSearch.autocompleteAddress(input: "st") { (result, error) in
    ///             if let callingError = error {
    ///                 print("failed to execute api \( callingError.localizedDescription ?? "-")")
    ///             } else {
    ///                 print("fetching result")
    ///                 print(result?.count ?? 0)
    ///                 result?.forEach({ (item) in
    ///                 print("===============")
    ///                 print(item.api)
    ///                 print(item.id ?? "")
    ///                 print(item.types ?? "")
    ///                 print(item.matched_substrings ?? "")
    ///                 print(item.description )
    ///                 print("===============")
    ///             })
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - input: String to be searched
    ///   - completionBlock: Callback function to return search results list or Error code
    /// - Returns: Internally calls Woosmap Address api and returns list of matching addresses
    /// - Throws: Throwing error with return function in Woosmap Error format
    ///   - Error in case of missing configuration
    ///   - Error in case of api failure
    public func autocompleteAddress(input: String, completionBlock: @escaping(SearchCompletionHandler)) {
        self.autocomplete(provider: .address, input: input, completionBlock: completionBlock)
    }

    /// Search location info with Localities provider
    ///
    /// Function return list of localities info for given search string
    ///
    /// Code
    ///  ---
    ///
    ///         objSearch.autocompleteLocalities(input: "st") { (result, error) in
    ///             if let callingError = error {
    ///                 print("failed to execute api \( callingError.localizedDescription ?? "-")")
    ///             } else {
    ///                 print("fetching result")
    ///                 print(result?.count ?? 0)
    ///                 result?.forEach({ (item) in
    ///                 print("===============")
    ///                 print(item.api)
    ///                 print(item.id ?? "")
    ///                 print(item.types ?? "")
    ///                 print(item.matched_substrings ?? "")
    ///                 print(item.description )
    ///                 print("===============")
    ///             })
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - input: String to be searched
    ///   - completionBlock: Callback function to return search result list or Error code
    /// - Returns: Search in Woosmap Localities api and return list of addresses
    /// - Throws: Throwing error with return function in Woosmap Error format
    ///   - Error in case of missing configuration
    ///   - Error in case of api failure
    public func autocompleteLocalities(
        input: String, completionBlock: @escaping(SearchCompletionHandler)) {
        self.autocomplete(provider: .localities, input: input, completionBlock: completionBlock)
    }

    /// Search location info with Google Places provider
    ///
    /// Function returns a list of locality info for a given search string
    ///
    /// Code
    ///  ---
    ///
    ///         objSearch.autocompletePlaces(input: "st") { (result, error) in
    ///             if let callingError = error {
    ///                 print("failed to execute api \( callingError.localizedDescription ?? "-")")
    ///             } else {
    ///                 print("fetching result")
    ///                 print(result?.count ?? 0)
    ///                 result?.forEach({ (item) in
    ///                 print("===============")
    ///                 print(item.api)
    ///                 print(item.id ?? "")
    ///                 print(item.types ?? "")
    ///                 print(item.matched_substrings ?? "")
    ///                 print(item.description )
    ///                 print("===============")
    ///             })
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - input: String to be searched
    ///   - completionBlock: Callback function to return search result list or Error code
    /// - Returns: Search in Google Places api and returns list of addresses
    /// - Throws: Throwing error with return function in Woosmap Error format
    ///   - Error in case of missing configuration
    ///   - Error in case of api failure
    public func autocompletePlaces(
        input: String, completionBlock: @escaping(SearchCompletionHandler)) {
        self.autocomplete(provider: .places, input: input, completionBlock: completionBlock)
    }

    /// Search location info with Store provider
    ///
    /// Function return list of locality info for given search string
    ///
    /// Code
    ///  ---
    ///
    ///         objSearch.autocompleteStore(input: "st") { (result, error) in
    ///             if let callingError = error {
    ///                 print("failed to execute api \( callingError.localizedDescription ?? "-")")
    ///             } else {
    ///                 print("fetching result")
    ///                 print(result?.count ?? 0)
    ///                 result?.forEach({ (item) in
    ///                 print("===============")
    ///                 print(item.api)
    ///                 print(item.id ?? "")
    ///                 print(item.types ?? "")
    ///                 print(item.matched_substrings ?? "")
    ///                 print(item.description )
    ///                 print("===============")
    ///             })
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - input: String to be searched
    ///   - completionBlock: Callback function to return search results list or Error code
    /// - Returns: Internally calls the Woosmap Store api and returns list of address
    /// - Throws: Throwing error with return function in Woosmap Error format
    ///   - Error in case of missing configuration
    ///   - Error in case of api failure
    public func autocompleteStore(
        input: String, completionBlock: @escaping(SearchCompletionHandler)) {
        self.autocomplete(provider: .store, input: input, completionBlock: completionBlock)
    }
    /**
     Query the details api to get details of an item.
     
     - Parameter id: basic information for places
     - Parameter provider: Looking api to call
     - Parameter completionBlock: Return search result or Error code
     - Returns: Return information of given places or error code in case the function fails.
     - throws: Error In case of missing configuration
     */

    /// Query the details api to get details of an item.
    ///
    /// Function return Locality info for given placeid
    ///
    /// Code
    ///  ---
    ///
    ///         objSearch.details(input: "s", provider:.place) { (result, error) in
    ///             if let callingError = error {
    ///                 print("failed to execute api \( callingError.localizedDescription ?? "-")")
    ///             } else {
    ///                 print("fetching result")
    ///                 print("===============")
    ///                 print(result.api)
    ///                 print(result.id ?? "")
    ///                 print(result.types ?? "")
    ///                 print(result.matched_substrings ?? "")
    ///                 print(result.description )
    ///                 print("===============")
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - id: basic information for places
    ///   - provider: look for api to be called
    ///   - completionBlock: Callback function to return Address info or Error code
    /// - Returns: Search in Woosmap Store api and return list of address
    /// - Throws: Throwing error with return function in Woosmap Error format
    ///   - Error in case of missing configuration
    ///   - Error in case of api failure
    public func details(id: String,
                        provider: SearchProviderType,
                        completionBlock: @escaping(DetailCompletionHandler)) {
        let configItem  = providerConfig.first { (item) -> Bool in
            return item.searchType == provider
        }
        guard let config =  configItem else {
            return completionBlock(nil, WoosmapError.Error(message: "Configuration is missing", statusText: "Missing", status: nil))
        }
        var searchProvider: AbstractProvider
        switch provider {
        case .localities:
            searchProvider = LocalitiesProvider.init(config)
        case .places:
            searchProvider = PlacesProvider.init(config)
        case .address:
            searchProvider = AddressProvider.init(config)
        case .store:
            searchProvider = StoreProvider.init(config)
        }
        searchProvider.details(id) { (result, error) in
            DispatchQueue.main.async {
                if let callError = error {
                    completionBlock(nil, WoosmapError.Error(message: callError.localizedDescription, statusText: callError.errorDescription, status: callError.status))
                } else {
                    completionBlock(result, nil)
                }
            }
        }

    }

}
