//
//  Endpoint.swift
//  Multisearch
//
//  Created by apple on 31/03/21.
//

import Foundation

/// Endpoint extension for google
struct EndpointGoogle {
    let path: String
    let queryItems: [URLQueryItem]?
}

extension EndpointGoogle {
    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = Constants.URLGoogleMap
        components.path = path
        components.queryItems = queryItems
        components.percentEncodedQuery = components.percentEncodedQuery?
            .replacingOccurrences(of: "+", with: "%2B")
            .replacingOccurrences(of: ",", with: "%2C")
        return components.url
    }
}
