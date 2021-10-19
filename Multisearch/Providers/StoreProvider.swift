//
//  StoreProvider.swift
//  Multisearch
//
//  Created by apple on 29/04/21.
//

import UIKit

class StoreProvider: AbstractProvider {
    private let currentConfig: ProviderConfig
    private var apiclient = APIClient()
    private var configParam: ConfigParam?

    /// Initialize provider with given config
    /// - Parameter config: Configuration setting
    required init(_ config: ProviderConfig) {
        self.currentConfig = config
    }

    /// Format Query being passed to api
    /// - Returns: List of formatted Query string
    func getQueryParam() -> [URLQueryItem] {
        return Utils.formatQuery(apikey: currentConfig.key, configParam: configParam)
    }

    /// Getting list of addresses matching with the search
    /// - Parameters:
    ///   - input: Address string
    ///   - completionBlock: Callback function, Returning list AutocompleteResponseItem and Api error, if any
    func search(_ input: String, completionBlock: @escaping ([AutocompleteResponseItem]?, APIClient.Error?) -> Void) {
        configParam = self.currentConfig.param
        let searchItem = "localized:\"\(input)\""
        if configParam == nil {
            configParam = ConfigParam(query: searchItem)
        } else {
            if (configParam?.query) != nil {
                configParam?.query?.append(searchItem)
            } else {
                configParam?.query = [searchItem]
            }
        }

        let searchQuery = self.getQueryParam()

        apiclient.searchStore(searchQuery) { ( result, errors) in
            completionBlock(result, errors)
        }
    }

    /// Getting Location Detail
    /// - Parameters:
    ///   - placeid: Location id
    ///   - completionBlock: Callback function, Returning DetailsResponseItem and Api error, if any
    func details(_ placeid: String, completionBlock: @escaping (DetailsResponseItem?, APIClient.Error?) -> Void) {

        configParam = self.currentConfig.param
        let searchItem = "idstore:\"\(placeid)\""
        if configParam == nil {
            configParam = ConfigParam(query: searchItem)
        } else {
            if (configParam?.query) != nil {
                configParam?.query?.append(searchItem)
            } else {
                configParam?.query = [searchItem]
            }
        }
        let searchQuery = self.getQueryParam()

        apiclient.searchStoreDetail(searchQuery) { (result, errors) in
            completionBlock(result, errors)
        }

    }
}
