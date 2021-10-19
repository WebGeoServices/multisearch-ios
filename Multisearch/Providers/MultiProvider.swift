//
//  MultiProvider.swift
//  Multisearch
//
//  Created by apple on 01/05/21.
//

import UIKit

/// Use to search from multiple providers, apply search score to prioritize search result
class MultiProvider {

    /// Structure of Result collector
    struct ResultCollector {
        var resultType: SearchProviderType
        var result: [AutocompleteResponseItem]?
    }

    public typealias MultiSearchCompletionHandler = (_ userResponse: [AutocompleteResponseItem]?,
                                                     _ error: WoosmapError?) -> Void

    /// List of available search providers
    private var avaliableProvider: [ProviderConfig] = []

    /// Result collector bucket
    private var resultBucket: [ResultCollector] = []

    /// Error collector bucket
    private var errorBucket: [WoosmapError]?

    /// Last searched string
    private var searchingString: String = ""

    /// Callback receiver for autocomplete
    private var multiSearchCompletionHandler: MultiSearchCompletionHandler?

    /// Check result from scoring provider available during call. If result available, skip remaining scoring providers
    private var resultFromScoringProvider: Bool =  false

    /// Activate MultiProvider with list of providers
    /// - Parameter providers: List of provider
    init(providers: [ProviderConfig]) {
        avaliableProvider = providers

    }

    /// Search multiple search providers and return result with proper sequence and scoring
    /// - Parameters:
    ///   - input: Address to be searched
    ///   - completionBlock: Call back result to calling function
    public func autocomplete(input: String, completionBlock: @escaping(MultiSearchCompletionHandler)) {
        // Setting up variable
        searchingString = input
        multiSearchCompletionHandler = completionBlock
        resultBucket.removeAll()
        resultFromScoringProvider = false
        avaliableProvider.forEach { (item) in
            resultBucket.append(ResultCollector.init(resultType: item.searchType, result: nil))
        }
        autocompleteApi(input: searchingString, provider: avaliableProvider)
    }

    /// Utility function to return matching provider for a given search config
    /// - Parameter config: Configuration setting
    /// - Returns: AbstractProvider for calling provider config
    private func getProvider(_ config: ProviderConfig) -> AbstractProvider {
        var searchProvider: AbstractProvider
        switch config.searchType {
        case .localities:
            searchProvider = LocalitiesProvider.init(config)
        case .places:
            searchProvider = PlacesProvider.init(config)
        case .address:
            searchProvider = AddressProvider.init(config)
        case .store:
            searchProvider = StoreProvider.init(config)
        }
        return searchProvider
    }

    /// Recursive call of provider config to fetch result form all search providers
    /// - Parameters:
    ///   - input: Address
    ///   - provider: Configuration for given provider
    private func autocompleteApi(input: String, provider: [ProviderConfig]) {
        if provider.count == 0 {
            // bubble result on function
            if let handlerAvaliable = multiSearchCompletionHandler {
                if let collectedErrors = errorBucket {
                    handlerAvaliable(nil, collectedErrors.first)
                    self.errorBucket = nil
                } else {
                    var result: [AutocompleteResponseItem] = []
                    resultBucket.forEach { (item) in
                        if let matchingResult = item.result {
                            matchingResult.forEach { (item) in
                                result.append(item)
                            }
                        }
                    }
                    handlerAvaliable(result, nil)
                }
            }

        } else {
            var remainingProvider: [ProviderConfig] = provider
            let processingProvider = remainingProvider.removeFirst()
            let searchProvider: AbstractProvider = getProvider(processingProvider)
            // print("called API \(processingProvider.searchType)")
            if (resultFromScoringProvider == false ||
                    processingProvider.ignoreFallbackBreakpoint == true) &&
                processingProvider.minInputLength <= input.length {
                searchProvider.search(input) { (result, error) in
                    if let searchResult = result {
                        if processingProvider.ignoreFallbackBreakpoint {
                            self.addInResult(searchType: processingProvider.searchType, result: searchResult)

                        } else {
                            // Check for Fuse Scroring
                            let scoreResult = FuseJS.shared.callFuseJavaSDK(searchResult, input, Fuseparameter.init(threshold: processingProvider.fallbackBreakpoint))
                            if scoreResult.count > 0 {
                                self.resultFromScoringProvider = true
                                self.addInResult(searchType: processingProvider.searchType, result: scoreResult)
                            }
                        }
                    }

                    if let searchError = error {
                        if self.errorBucket == nil {
                            self.errorBucket = []
                        }
                        self.errorBucket?.append(WoosmapError.Error(message: searchError.localizedDescription, statusText: Constants.apiFailed, status: nil))
                        // pop error back to caller and ignore remaining provider
                        remainingProvider.removeAll()
                    }

                    self.autocompleteApi(input: input, provider: remainingProvider)
                }
            } else {
                // Short input length, remove processing provider which set ignoreFallbackBreakPoint == false
                if processingProvider.minInputLength > input.length {
                    remainingProvider.removeAll { matchprovider in
                        return matchprovider.ignoreFallbackBreakpoint == false
                    }
                }
                self.autocompleteApi(input: input, provider: remainingProvider)
            }

        }
    }

    /// Utility function to collect result from all providers
    /// - Parameters:
    ///   - searchType: provider type
    ///   - result: List of search results
    private func addInResult(searchType: SearchProviderType, result: [AutocompleteResponseItem]) {
        if let resultIndex = resultBucket.firstIndex(where: { (item) -> Bool in
            return (item.resultType == searchType)
        }) {
            resultBucket[resultIndex] = ResultCollector.init(resultType: searchType, result: result)
        }

    }

}
