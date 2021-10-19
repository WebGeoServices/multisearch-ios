//
//  EndpointWoosMap.swift
//  Multisearch
//
//  Created by apple on 24/04/21.
//

import Foundation

/// Endpoint Extension for Woosmap
struct EndpointWoosMap {
    let path: String
    let queryItems: [URLQueryItem]?
}

extension EndpointWoosMap {
    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = Constants.URLWoosMap
        components.path = path
        components.queryItems = queryItems
        components.percentEncodedQuery = components.percentEncodedQuery?
            .replacingOccurrences(of: "+", with: "%2B")
            .replacingOccurrences(of: "/", with: "%2F")
            .replacingOccurrences(of: ",", with: "%2C")
        return components.url
    }
}
