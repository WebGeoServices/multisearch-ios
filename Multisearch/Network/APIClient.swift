//
//  APIClient.swift
//  Multisearch
//
//  Created by apple on 31/03/21.
//

import Foundation

/// Web API client protocol
protocol APIClientProtocol: Any {

    typealias ApiSearchHandler = (_ userResponse: [AutocompleteResponseItem]?, _ error: APIClient.Error?) -> Void

    typealias ApiDetailHandler = ( _ userResponse: DetailsResponseItem?, _ error: APIClient.Error?) -> Void

    func searchPlaces(_ urlQuery: [URLQueryItem],
                      completionBlock: @escaping (ApiSearchHandler))

    func searchPlacesDetail(_ urlQuery: [URLQueryItem],
                            completionBlock: @escaping (ApiDetailHandler))

    func searchLocality(_ urlQuery: [URLQueryItem],
                        completionBlock: @escaping (ApiSearchHandler))

    func searchLocalityDetail(_ urlQuery: [URLQueryItem],
                              completionBlock: @escaping (ApiDetailHandler))

    func searchAddress(_ urlQuery: [URLQueryItem],
                       completionBlock: @escaping (ApiSearchHandler))

    func searchAddressDetail(_ urlQuery: [URLQueryItem],
                             completionBlock: @escaping (ApiDetailHandler))

    func searchStore(_ urlQuery: [URLQueryItem],
                     completionBlock: @escaping (ApiSearchHandler))

    func searchStoreDetail(_ urlQuery: [URLQueryItem],
                           completionBlock: @escaping (ApiDetailHandler))
}

/// Web API client
class APIClient: APIClientProtocol {

    /// Capture app identifier
    let bundleID: String = Bundle.main.bundleIdentifier ?? "-"

    /// Session for web client
    fileprivate let defaultSession: URLSession = {
        // To avoid warning on device : Query fired: did not receive all answers in time for
//        let configuration = URLSessionConfiguration.default
//        configuration.timeoutIntervalForRequest = 10.0
//        configuration.timeoutIntervalForResource = 10.0
//        return URLSession(configuration: configuration, delegate: nil, delegateQueue: nil)
        return URLSession.shared
    }()

    /// APIClient initialization
    public init() { }

    /// Google Autocomplete API
    /// - Parameters:
    ///   - urlQuery: Query passed for autocomplete
    ///   - completionBlock: List of places from Google
    public func searchPlaces(_ urlQuery: [URLQueryItem], completionBlock: @escaping (ApiSearchHandler)) {

        guard let url = EndpointGoogle(path: Constants.URLPlacesAPI, queryItems: urlQuery).url else {
            completionBlock( nil, .brokenURL)
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")

        let task = defaultSession.dataTask(with: urlRequest) { data, urlResponse, error in
            if let error = error {
                completionBlock( nil, .http(message: error.localizedDescription, statusText: Constants.noInternet, status: 0))
                return
            }
            guard let httpResponse = urlResponse as? HTTPURLResponse else {
                return
            }
            if httpResponse.statusCode == 200 {
                guard let data = data else {
                    return
                }
                do {
                    var result: [AutocompleteResponseItem] = []
                    let jsonStructure = try JSONDecoder().decode(JSONAny.self, from: data)
                    if let value = jsonStructure.value as? [String: Any] {
                        if let errormessage = value["error_message"] as? String {
                            completionBlock( nil, .http(message: errormessage, statusText: "REQUEST DENIED", status: 400))
                            return
                        }
                        if let poiInfo = value["predictions"] as? [[String: Any]] {
                            poiInfo.forEach { (localityItem) in
                                if let description = localityItem["description"] as? String {
                                    result.append(AutocompleteResponseItem.init(description: description, searchtype: .places, input: localityItem))
                                }
                            }
                        }
                    }
                    completionBlock( result, nil)
                } catch let error {
                    completionBlock( nil, .serialization(error.localizedDescription))
                }
            } else {
                completionBlock( nil, .http(message: Constants.failedGooglePlacesRequest, statusText: Constants.badRequest, status: 400))
            }
        }
        task.resume()
    }

    /// Google places detail API
    /// - Parameters:
    ///   - urlQuery: Query parameters
    ///   - completionBlock: Places information info from Google
    public func searchPlacesDetail(_ urlQuery: [URLQueryItem],
                                   completionBlock: @escaping (ApiDetailHandler)) {

        guard let url = EndpointGoogle(path: Constants.URLPlacesDetailAPI, queryItems: urlQuery).url else {
            completionBlock( nil, .brokenURL)
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        let task = defaultSession.dataTask(with: urlRequest) { data, urlResponse, error in
            if let error = error {
                completionBlock( nil, .http(message: error.localizedDescription, statusText: Constants.noInternet, status: 0))
                return
            }
            guard let httpResponse = urlResponse as? HTTPURLResponse else {
                return
            }
            if httpResponse.statusCode == 200 {
                guard let data = data else {
                    return
                }
                do {
                    let jsonStructure = try JSONDecoder().decode(JSONAny.self, from: data)
                    if let value = jsonStructure.value as? [String: Any] {
                        if let errormessage = value["error_message"] as? String {
                            completionBlock( nil, .http(message: errormessage, statusText: "REQUEST DENIED", status: 400))
                            return
                        }
                        if let poiInfo = value["result"] as? [String: Any] {
                            guard let placeID = poiInfo["place_id"] as? String else {
                                completionBlock( nil, .serialization(Constants.formatNotMatching))
                                return
                            }
                            var formattedAddress = ""
                            if let poiformattedAddress = poiInfo["formatted_address"] as? String {
                                formattedAddress = poiformattedAddress
                            }
                            var name = ""
                            if let poiname = poiInfo["name"] as? String {
                                name = poiname
                            }
                            var types: [String] = []
                            if let poitypes = poiInfo["types"] as? [String] {
                                types = poitypes
                            }
                            let result = DetailsResponseItem.init(api: .places,
                                                                  id: placeID,
                                                                  formattedAddress: formattedAddress,
                                                                  name: name,
                                                                  types: types,
                                                                  input: poiInfo)
                            completionBlock( result, nil)

                        } else {
                            if let status = value["status"] as? String {
                                completionBlock( nil, .serialization(status))
                            } else {
                                completionBlock( nil, .serialization(Constants.invalidRequest))
                            }
                        }
                    } else {
                        completionBlock( nil, .serialization(Constants.invalidRequest))
                    }
                } catch let error {
                    completionBlock( nil, .serialization(error.localizedDescription))
                }
            } else if httpResponse.statusCode >= 400 {
                guard let data = data else {
                    return
                }
                completionBlock( nil, self.capture400Error(data: data))
            } else {
                completionBlock( nil, .http(message: Constants.failedGooglePlacesRequest, statusText: Constants.badRequest, status: 400))
            }
        }
        task.resume()
    }

    /// Woosmap Locality API
    /// - Parameters:
    ///   - urlQuery: Query parameters
    ///   - completionBlock: Locality list info from Woosmap database
    public func searchLocality(_ urlQuery: [URLQueryItem], completionBlock: @escaping (ApiSearchHandler)) {

        guard let url = EndpointWoosMap(path: Constants.URLLocalitiesAPI, queryItems: self.replaceKeyWithPrivateKey(urlQuery)).url else {
            completionBlock( nil, .brokenURL)
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.addValue("http://localhost.ios:\(bundleID)", forHTTPHeaderField: "Referer")

        let task = defaultSession.dataTask(with: urlRequest) { data, urlResponse, error in
            if let error = error {
                completionBlock( nil, .http(message: error.localizedDescription, statusText: Constants.noInternet, status: 0))
                return
            }
            guard let httpResponse = urlResponse as? HTTPURLResponse else {
                return
            }

            if httpResponse.statusCode == 200 {
                guard let data = data else {
                    return
                }
                do {
                    var result: [AutocompleteResponseItem] = []
                    let jsonStructure = try JSONDecoder().decode(JSONAny.self, from: data)
                    if let value = jsonStructure.value as? [String: Any] {
                        if let localities = value["localities"] as? [[String: Any]] {
                            localities.forEach { (localityItem) in
                                if let description = localityItem["description"] as? String {
                                    result.append(AutocompleteResponseItem.init(description: description, searchtype: .localities, input: localityItem))
                                }
                            }
                        }
                    }
                    completionBlock( result, nil)
                } catch let error {
                    completionBlock( nil, .serialization(error.localizedDescription))
                }
            } else if httpResponse.statusCode >= 400 {
                guard let data = data else {
                    return
                }
                completionBlock( nil, self.capture400Error(data: data))
            } else {
                completionBlock( nil, .http(message: Constants.failedLocalitiesRequest, statusText: Constants.badRequest, status: 400))
            }
        }
        task.resume()
    }

    /// Woosmap locality detail API
    /// - Parameters:
    ///   - urlQuery: Query parameters
    ///   - completionBlock: Locality detail info from Woosmap database
    public func searchLocalityDetail(_ urlQuery: [URLQueryItem], completionBlock: @escaping (ApiDetailHandler)) {

        guard let url = EndpointWoosMap(path: Constants.URLLocalitiesDetailAPI, queryItems: self.replaceKeyWithPrivateKey(urlQuery)).url else {
            completionBlock( nil, .brokenURL)
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.addValue("http://localhost.ios:\(bundleID)", forHTTPHeaderField: "Referer")

        let task = defaultSession.dataTask(with: urlRequest) { data, urlResponse, error in
            if let error = error {
                completionBlock( nil, .http(message: error.localizedDescription, statusText: Constants.noInternet, status: 0))
                return
            }
            guard let httpResponse = urlResponse as? HTTPURLResponse else {
                return
            }
            if httpResponse.statusCode == 200 {
                guard let data = data else {
                    return
                }
                do {
                    let jsonStructure = try JSONDecoder().decode(JSONAny.self, from: data)
                    if let value = jsonStructure.value as? [String: Any] {
                        if let poiInfo = value["result"] as? [String: Any] {
                            guard let publicID = poiInfo["public_id"] as? String else {
                                completionBlock( nil, .serialization(Constants.formatNotMatching))
                                return
                            }
                            var formattedAddress = ""
                            if let poiformattedAddress = poiInfo["formatted_address"] as? String {
                                formattedAddress = poiformattedAddress
                            }
                            var name = ""
                            if let poiname = poiInfo["name"] as? String {
                                name = poiname
                            }
                            var types: [String] = []
                            if let poitypes = poiInfo["types"] as? [String] {
                                types = poitypes
                            }
                            let result = DetailsResponseItem.init(api: .localities,
                                                                  id: publicID,
                                                                  formattedAddress: formattedAddress,
                                                                  name: name,
                                                                  types: types,
                                                                  input: poiInfo)
                            completionBlock( result, nil)

                        } else {
                            completionBlock( nil, .serialization(Constants.invalidRequest))
                        }
                    } else {
                        completionBlock( nil, .serialization(Constants.invalidRequest))
                    }
                } catch let error {
                    completionBlock( nil, .serialization(error.localizedDescription))
                }
            } else if httpResponse.statusCode >= 400 {
                guard let data = data else {
                    return
                }
                completionBlock( nil, self.capture400Error(data: data))
            } else {
                completionBlock( nil, .http(message: Constants.failedLocalitiesRequest, statusText: Constants.badRequest, status: 400))
            }
        }
        task.resume()
    }

    /// Woosmap Address API
    /// - Parameters:
    ///   - urlQuery: Query parameters
    ///   - completionBlock: Address list info from Woosmap database
    public func searchAddress(_ urlQuery: [URLQueryItem], completionBlock: @escaping (ApiSearchHandler)) {

        guard let url = EndpointWoosMap(path: Constants.URLAddressAPI, queryItems: self.replaceKeyWithPrivateKey(urlQuery)).url else {
            completionBlock( nil, .brokenURL)
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.addValue("http://localhost.ios:\(bundleID)", forHTTPHeaderField: "Referer")

        let task = defaultSession.dataTask(with: urlRequest) { [self] data, urlResponse, error in
            if let error = error {
                completionBlock( nil, .http(message: error.localizedDescription, statusText: Constants.noInternet, status: 0))
                return
            }
            guard let httpResponse = urlResponse as? HTTPURLResponse else {
                return
            }
            if httpResponse.statusCode == 200 {
                guard let data = data else {
                    return
                }
                do {
                    var result: [AutocompleteResponseItem] = []
                    let jsonStructure = try JSONDecoder().decode(JSONAny.self, from: data)
                    if let value = jsonStructure.value as? [String: Any] {
                        if let poiInfo = value["predictions"] as? [[String: Any]] {
                            poiInfo.forEach { (poiItem) in
                                if let description = poiItem["description"] as? String {
                                    var modifiedPOI = poiItem
                                    modifiedPOI["public_id"] = description.toBase64()
                                    result.append(AutocompleteResponseItem.init(description: description, searchtype: .address, input: modifiedPOI))
                                }
                            }
                        } else {
                            if let errorMsg = value["error_message"] as? String {
                                completionBlock( nil, .http(message: errorMsg, statusText: Constants.badRequest, status: 400))
                            } else {
                                completionBlock( nil, .serialization(Constants.invalidRequest))
                            }
                        }
                    }
                    completionBlock( result, nil)
                } catch let error {
                    completionBlock( nil, .serialization(error.localizedDescription))
                }
            } else if httpResponse.statusCode >= 400 {
                guard let data = data else {
                    return
                }
                completionBlock( nil, self.capture400Error(data: data))

            } else {
                completionBlock( nil, .http(message: Constants.failedAddressRequest, statusText: Constants.badRequest, status: 400))
            }
        }
        task.resume()
    }

    /// Woosmap Address detail API
    /// - Parameters:
    ///   - urlQuery: Query parameters
    ///   - completionBlock: Address detail info from Woosmap database
    public func searchAddressDetail(_ urlQuery: [URLQueryItem], completionBlock: @escaping (ApiDetailHandler)) {

        guard let url = EndpointWoosMap(path: Constants.URLAddressDetailAPI, queryItems: self.replaceKeyWithPrivateKey(urlQuery)).url else {
            completionBlock( nil, .brokenURL)
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.addValue("http://localhost.ios:\(bundleID)", forHTTPHeaderField: "Referer")

        let task = defaultSession.dataTask(with: urlRequest) { data, urlResponse, error in
            if let error = error {
                completionBlock( nil, .http(message: error.localizedDescription, statusText: Constants.noInternet, status: 0))
                return
            }
            guard let httpResponse = urlResponse as? HTTPURLResponse else {
                return
            }
            if httpResponse.statusCode == 200 {
                guard let data = data else {
                    return
                }
                do {
                    let jsonStructure = try JSONDecoder().decode(JSONAny.self, from: data)
                    if let value = jsonStructure.value as? [String: Any] {
                        if let results = value["results"] as? [[String: Any]] {
                            if let poiInfo = results.first {
                                guard let formattedAddress = poiInfo["formatted_address"] as? String else {
                                    completionBlock( nil, .serialization(Constants.formatNotMatching))
                                    return
                                }
                                var types: [String] = []
                                if let poitypes = poiInfo["types"] as? [String] {
                                    types = poitypes
                                }
                                let result = DetailsResponseItem.init(api: .address,
                                                                      id: formattedAddress.toBase64(),
                                                                      formattedAddress: formattedAddress,
                                                                      name: formattedAddress,
                                                                      types: types,
                                                                      input: poiInfo)
                                completionBlock( result, nil)
                            } else {
                                completionBlock( nil, .serialization(Constants.invalidRequest))
                            }
                        } else {
                            if let errorMsg = value["error_message"] as? String {
                                completionBlock( nil, .http(message: errorMsg, statusText: Constants.badRequest, status: 400))
                            } else {
                                completionBlock( nil, .serialization(Constants.invalidRequest))
                            }
                        }
                    } else {
                        completionBlock( nil, .serialization(Constants.invalidRequest))
                    }
                } catch let error {
                    completionBlock( nil, .serialization(error.localizedDescription))
                }
            } else if httpResponse.statusCode >= 400 {
                guard let data = data else {
                    return
                }
                completionBlock( nil, self.capture400Error(data: data))
            } else {
                completionBlock( nil, .http(message: Constants.failedAddressRequest, statusText: Constants.badRequest, status: 400))
            }
        }
        task.resume()
    }
    /// Woosmap Store API
    /// - Parameters:
    ///   - urlQuery: Query parameters
    ///   - completionBlock: Store list info from Woosmap database
    public func searchStore(_ urlQuery: [URLQueryItem], completionBlock: @escaping (ApiSearchHandler)) {

        guard let url = EndpointWoosMap(path: Constants.URLStoreAPI, queryItems: self.replaceKeyWithPrivateKey(urlQuery)).url else {
            completionBlock( nil, .brokenURL)
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.addValue("http://localhost.ios:\(bundleID)", forHTTPHeaderField: "Referer")

        let task = defaultSession.dataTask(with: urlRequest) { [self] data, urlResponse, error in
            if let error = error {
                completionBlock( nil, .http(message: error.localizedDescription, statusText: Constants.noInternet, status: 0))
                return
            }
            guard let httpResponse = urlResponse as? HTTPURLResponse else {
                return
            }
            if httpResponse.statusCode == 200 {
                guard let data = data else {
                    return
                }
                do {
                    var result: [AutocompleteResponseItem] = []
                    let jsonStructure = try JSONDecoder().decode(JSONAny.self, from: data)
                    if let value = jsonStructure.value as? [String: Any] {
                        if let poiInfo = value["predictions"] as? [[String: Any]] {
                            poiInfo.forEach { (poiItem) in
                                if let description = poiItem["name"] as? String {
                                    result.append(AutocompleteResponseItem.init(description: description, searchtype: .store, input: poiItem))
                                }
                            }
                        }
                    }
                    completionBlock( result, nil)
                } catch let error {
                    completionBlock( nil, .serialization(error.localizedDescription))
                }
            } else if httpResponse.statusCode >= 400 {
                guard let data = data else {
                    return
                }
                completionBlock( nil, self.capture400Error(data: data))

            } else {
                completionBlock( nil, .http(message: Constants.failedStoreRequest, statusText: Constants.badRequest, status: 400))
            }
        }
        task.resume()
    }

    /// Woosmap Store detail API
    /// - Parameters:
    ///   - urlQuery: Query parameters
    ///   - completionBlock: Store detail info from Woosmap database
    public func searchStoreDetail(_ urlQuery: [URLQueryItem],
                                  completionBlock: @escaping (ApiDetailHandler)) {

        guard let url = EndpointWoosMap(path: Constants.URLStoreDetailAPI, queryItems: self.replaceKeyWithPrivateKey(urlQuery)).url else {
            completionBlock( nil, .brokenURL)
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.addValue("http://localhost.ios:\(bundleID)", forHTTPHeaderField: "Referer")

        let task = defaultSession.dataTask(with: urlRequest) { data, urlResponse, error in
            if let error = error {
                completionBlock( nil, .http(message: error.localizedDescription, statusText: Constants.noInternet, status: 0))
                return
            }
            guard let httpResponse = urlResponse as? HTTPURLResponse else {
                return
            }
            if httpResponse.statusCode == 200 {
                guard let data = data else {
                    return
                }
                do {
                    let jsonStructure = try JSONDecoder().decode(JSONAny.self, from: data)
                    if let value = jsonStructure.value as? [String: Any] {
                        if let features = value["features"] as? [[String: Any]] {
                            if let poiInfo = features.first {
                                if let properties = poiInfo["properties"] as? [String: Any] {

                                    guard let storeID = properties["store_id"] as? String else {
                                        completionBlock( nil, .serialization(Constants.formatNotMatching))
                                        return
                                    }
                                    var formattedAddress = ""
                                    if let address = properties["address"] as? [String: Any] {
                                        if let lines = address["lines"] as? [String] {
                                            formattedAddress = lines.map { item in
                                                                            item.cleanup()}.joined(separator: " ")
                                        }
                                    }
                                    var name = ""
                                    if let poiname = properties["name"] as? String {
                                        name = poiname
                                    }
                                    var types: [String] = []
                                    if let poitypes = properties["types"] as? [String] {
                                        types = poitypes
                                    }
                                    let result = DetailsResponseItem.init(api: .store,
                                                                          id: storeID,
                                                                          formattedAddress: formattedAddress,
                                                                          name: name,
                                                                          types: types,
                                                                          input: poiInfo)
                                    completionBlock( result, nil)
                                }

                            } else {
                                completionBlock( nil, .serialization(Constants.invalidRequest))
                            }
                        } else {
                            completionBlock( nil, .serialization(Constants.invalidRequest))
                        }
                    } else {
                        completionBlock( nil, .serialization(Constants.invalidRequest))
                    }
                } catch let error {
                    completionBlock( nil, .serialization(error.localizedDescription))
                }
            } else if httpResponse.statusCode >= 400 {
                guard let data = data else {
                    return
                }
                completionBlock( nil, self.capture400Error(data: data))
            } else {
                completionBlock( nil, .http(message: Constants.failedStoreRequest,
                                            statusText: Constants.badRequest,
                                            status: 400))
            }
        }
        task.resume()
    }

    /// Corrected Public or private key in Query
    /// - Parameter urlQuery: Query structure pass to API Call
    /// - Returns: Modified version of Query parameter
    private func replaceKeyWithPrivateKey(_ urlQuery: [URLQueryItem]) -> [URLQueryItem] {
        var output: [URLQueryItem] = []
        urlQuery.forEach { (query) in
            if query.name == "key" {
                if query.value!.starts(with: "woos-") {
                    output.append(query)
                } else {
                    output.append(URLQueryItem(name: "private_key", value: query.value))
                }

            } else {
                output.append(query)
            }
        }
        return output
    }
    private func capture400Error(data: Data) -> APIClient.Error {
        do {
            let errorResponse = try JSONDecoder().decode([String: String].self, from: data)
            if let errorString = self.captureError(httpError: errorResponse) {
                return .http(message: errorString, statusText: Constants.statusFailed, status: 400)
            } else {
                return .http(message: Constants.missingErrorInfo, statusText: Constants.statusFailed, status: 400)
            }
        } catch _ {
            // Serialization failed. Skipped actual error to display
            return .http(message: Constants.unableToProcessErrorRequest, statusText: Constants.statusFailed, status: 400)
        }
    }

    private func captureError(httpError: [String: String]) -> String? {
        if let errorString = httpError["value"] {
            return errorString
        }
        if let errorString = httpError["detail"] {
            return errorString
        }
        return nil
    }
}

extension APIClient {
    enum Error: LocalizedError, Equatable {
        case brokenURL
        case http(message: String, statusText: String?, status: Int?)
        case serialization(String)
    }
}
extension APIClient.Error {
    public var errorDescription: String? {
        switch self {
        case let .http(_, statusText, _):
            return statusText
        case .brokenURL:
            return "missing URL"
        case let .serialization(message):
            return message
        }
    }

    /// Description of error
    public var localizedDescription: String? {
        switch self {
        case let .http(message, _, _):
            return message
        case .brokenURL:
            return "missing URL"
        case let .serialization(message):
            return message
        }
    }

    /// Error number
    public var status: Int {
        switch self {
        case let .http(_, _, status):
            return status ?? -1
        case .brokenURL:
            return -1
        case .serialization:
            return -1
        }
    }
}
