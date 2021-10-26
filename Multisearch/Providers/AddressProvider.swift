//
//  AddressProvider.swift
//  Multisearch
//
//  Created by apple on 29/04/21.
//

import UIKit

class AddressProvider: AbstractProvider {
    private let currentConfig: ProviderConfig
    private var apiclient = APIClient()
    /// Initialize provider with given config
    /// - Parameter config: Configuration setting
    required init(_ config: ProviderConfig) {
        self.currentConfig = config
    }

    /// Format Query being passed to api
    /// - Returns: List of formated Query string
    func getQueryParam() -> [URLQueryItem] {
        var urlQuery = Utils.formatQuery(apikey: currentConfig.key, configParam: currentConfig.param)
        urlQuery.append(URLQueryItem.init(name: "cc_format", value: "alpha2"))
        return urlQuery
    }

    /// Getting list of addresses matching with the search
    /// - Parameters:
    ///   - input: Address string
    ///   - completionBlock: Callback function, Returning list AutocompleteResponseItem and Api error if any
    func search(_ input: String, completionBlock: @escaping ([AutocompleteResponseItem]?, APIClient.Error?) -> Void) {
        var searchQuery = self.getQueryParam()
        searchQuery.append(URLQueryItem.init(name: "input", value: input))
        apiclient.searchAddress(searchQuery) { ( result, errors) in
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
        apiclient.searchAddressDetail(searchQuery) { (result, errors) in
            completionBlock(result, errors)
        }

    }
}
