//
//  LocalitiesProvider.swift
//  Multisearch
//
//  Created by apple on 24/04/21.
//

import UIKit

class LocalitiesProvider: AbstractProvider {

    private let currentConfig: ProviderConfig
    private var apiclient = APIClient()

    /// Initialize provider with given config
    /// - Parameter config: Configuration setting
    required init(_ config: ProviderConfig) {
        self.currentConfig = config
    }

    /// Format Query being passed to api
    /// - Returns: List of formatted Query string
    func getQueryParam() -> [URLQueryItem] {
        let urlQuery = Utils.formatQuery(apikey: currentConfig.key, configParam: currentConfig.param)
        return urlQuery
    }

    /// Getting list of addresses matching with the search
    /// - Parameters:
    ///   - input: Address string
    ///   - completionBlock: Callback function, Returning list AutocompleteResponseItem and Api error if any
    func search(_ input: String, completionBlock: @escaping ([AutocompleteResponseItem]?, APIClient.Error?) -> Void) {
        var searchQuery = self.getQueryParam()
        searchQuery.append(URLQueryItem.init(name: "input", value: input))
        apiclient.searchLocality(searchQuery) { ( result, errors) in
            completionBlock(result, errors)
        }
    }

    /// Getting Location Detail
    /// - Parameters:
    ///   - placeid: Location id
    ///   - completionBlock: Callback function, Returning DetailsResponseItem and Api error if any
    func details(_ placeid: String, completionBlock: @escaping (DetailsResponseItem?, APIClient.Error?) -> Void) {
        var searchQuery = self.getQueryParam()
        searchQuery.append(URLQueryItem.init(name: "public_id", value: placeid))
        apiclient.searchLocalityDetail(searchQuery) { ( result, errors) in
            completionBlock(result, errors)
        }

    }

}
