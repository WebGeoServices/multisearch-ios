//
//  WoosmapConfig.swift
//  Multisearch
//
//  Created by apple on 19/04/21.
//

import UIKit

/// Available search provider
public enum SearchProviderType: String {
    case store = "Store"
    case localities = "Localities"
    case address = "Address"
    case places = "Places"
}

/// Available data format with Woosmap api
public enum DataFormat: String {
    case standard
    case advanced
}
// MARK: - ConfigParam

/// API configuration structure
/// This class helps to collect all query parameter required for api calls to fine tune results
public class ConfigParam: Codable {

    /// This is generating component query string like &component=country:FR|country:IN
    ///
    /// A grouping of places to which you would like to restrict your results. Currently, you can use components to filter over countries. Countries must be passed as a two character, ISO 3166-1 Alpha-2 compatible country code. For example: components=country:fr would restrict your results to places within France and components=country:fr-fr returns locations only in Metropolitan France. Multiple countries must be passed as multiple country:XX filters, with the pipe character (|) as a separator. For example: components=country:gb|country:fr|country:be|country:sp|country:it would restrict your results to city names or postal codes within the United Kingdom, France, Belgium, Spain and Italy.
    let components: Components?

    /// This is generating a query string like &types=metrostation|hospital
    ///
    /// Not specifying any type will only query locality and postal_code
    var types: [String]?

    /// This is generating language query string like &language=fr
    ///
    /// The language code, indicating in which language the results should be returned, if possible. Searches are also biased to the selected language; results in the selected language may be given a higher ranking. If language is not supplied, the Localities service will use the default language of each country. No language necessary for postal_code request
    var language: String?

    /// parameter which is a search query combining one or more search clauses. Each search clause is made up of three parts structured as field : operator value. , e.g. name:="My cool store"
    var query: [String]?

    /// Defaults to ‘standard’, can be set to ‘advanced’ to retrieve postal codes outside western Europe
    ///
    /// Two values for this parameter: standard or advanced. By default, if the parameter is not defined, value is set as standard. The advanced value opens suggestions to worldwide postal codes in addition to postal codes for Western Europe. A dedicated option subject to specific billing on your license is needed to use this parameter. Please contact us if you are interested in using this parameter and you do not have subscribed the proper option yet.
    var data: String?

    /// Can be set to ‘postal_code’ to search localities by name or postal code. It is only available for France and Italy
    ///
    /// If set, this parameter allows a refined search over locality names that bears the same postal code. By triggering this parameter, integrators will benefit from a search spectrum on the locality type that includes postal codes. To avoid confusion, it is recommended not to activate this parameter along with the postal_code type which could lead to duplicate locations. Also, the default description returned by the API changes to name (postal code), admin_1, admin_0. It is only available for France and Italy.
    var extended: String?

    /// Creating ConfigParam with component
    /// - Parameter components: components
    public init(components: Components) {
        self.components = components
    }

    /// Creating ConfigParam with components, types
    /// - Parameters:
    ///   - components: component query
    ///   - types: types query
    public init(components: Components, types: [String]) {
        self.components = components
        self.types = types
    }

    /// Creating ConfigParam with components, types, tags, language
    /// - Parameters:
    ///   - components: component query
    ///   - types: types query
    ///   - tags: tags query
    ///   - language: language query
    public init(components: Components? = nil, types: [String]? = nil, language: String? = nil, query: String? = nil, data: DataFormat? = nil, extended: String? = nil  ) {
        self.components = components
        self.types = types
        self.language = language
        if let query = query {
            self.query = [query]
        }
        if let tempData = data {
            self.data = tempData.rawValue
        }
        self.extended = extended
    }
}

// MARK: - UserDefined

/// User defined parameter structure
private class UserDefined: Codable {
    let key: String
    let query: [String]

    public init(key: String, queries: [String]) {
        self.key = key
        self.query = queries
    }
    public init(key: String, query: String) {
        self.key = key
        self.query = [query]
    }
}

// MARK: - Components

/// Components param use in api calls
public class Components: Codable {
    let country: [String]
    var language: String?

    public init(country: [String], language: String) {
        self.country = country
        self.language = language
    }
    public init(country: [String]) {
        self.country = country
    }
}

/// Configuration for search provider
/// This stores possible information to call search/detail apis from Woosmap or Google
public class ProviderConfig {
    let classid = UUID.init().uuidString
    let key: String
    var fallbackBreakpoint: Double = 0
    var minInputLength = 0
    var param: ConfigParam?
    let searchType: SearchProviderType
    var ignoreFallbackBreakpoint: Bool = false

    /// Created new provider configuration
    /// - Parameters:
    ///   - searchType: search type. Search api intent to call
    ///   - key: Authentication key to be able to call the API.
    ///   - fallbackBreakpoint: A number between 0 and 1 corresponding to the threashold of fallback. A value of 0 indicates that the results must contain at least one perfect match while 1 will match anything. If no value is specified, default values are applied for each API (1 for store, 0,4 for localities, 0,5 for address, 1 for places)
    ///   - minInputLength: Empty result will be sent by the API and no fallback will be triggered if the input length does not reach the minInputLength value
    ///   - param: Restriction on API call to minimize result in list
    public init(searchType: SearchProviderType, key: String, fallbackBreakpoint: Double? = nil, minInputLength: Int? = nil, param: ConfigParam? = nil) {
        self.searchType = searchType
        self.key =  key
        if let fallbackBreakpoint = fallbackBreakpoint {
            self.fallbackBreakpoint = fallbackBreakpoint
        } else {
            self.fallbackBreakpoint = self.defaultFallbackValue()
        }
        if self.fallbackBreakpoint == 0 {
            self.ignoreFallbackBreakpoint = true
        }
        if let minInputLength = minInputLength {
            self.minInputLength = minInputLength
        }

        self.param = param
    }

    /// Created new provider configuration
    /// - Parameters:
    ///   - searchType: search type. Search api intent to call
    ///   - key: Key for search api
    ///   - ignoreFallbackBreakpoint: In case of ignoreFallbackBreakpoint is true, it will add the result in *autocompleteMulti* routine without checking score of list items
    ///   - minInputLength: This is a cap on search string. Any Search string length less than this will be ignored while calling *autocompleteXXX* routine
    ///   - param: Restriction on API call to minimize result in list
    public init(searchType: SearchProviderType, key: String, ignoreFallbackBreakpoint: Bool, minInputLength: Int? = nil, param: ConfigParam? = nil) {
        self.searchType = searchType
        self.key =  key
        self.ignoreFallbackBreakpoint = ignoreFallbackBreakpoint
        if let minInputLength = minInputLength {
            self.minInputLength = minInputLength
        }
        self.param = param
        if ignoreFallbackBreakpoint == false {
            self.fallbackBreakpoint = self.defaultFallbackValue()
            if self.fallbackBreakpoint == 0 {
                self.ignoreFallbackBreakpoint = true
            }
        }
    }

    /// Created new provider configuration
    /// - Parameters:
    ///   - searchType: Search type. Search api intent to call
    ///   - key: Key for search api
    public init(searchType: SearchProviderType, key: String) {
        self.searchType = searchType
        self.key =  key
        self.minInputLength = 0
        self.fallbackBreakpoint = self.defaultFallbackValue()
        if self.fallbackBreakpoint == 0 {
            self.ignoreFallbackBreakpoint = true
        }
    }

    /// Default fallback breakpoint in case if it is not specified
    /// - Returns: breakpoint value
    private func defaultFallbackValue() -> Double {
        var defaultValue: Double = 0
        switch self.searchType {
        case .localities:
            defaultValue = 0.4
        case .store:
            defaultValue = 1.0
        case .address:
            defaultValue = 0.5
        case .places:
            defaultValue = 1.0
        }
        return defaultValue
    }

}
