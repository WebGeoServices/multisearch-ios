//
//  Utils.swift
//  Multisearch
//
//  Created by apple on 29/04/21.
//

import Foundation

/// Utility class to incorporate common routines for Multisearch
internal class Utils {

    /// Query Formater
    /// - Parameters:
    ///   - apikey: API secret  code
    ///   - configParam: Configuration specify for each provider
    /// - Returns: [URLQueryItem] in formated query structure
    static func formatQuery (apikey: String, configParam: ConfigParam?) -> [URLQueryItem] {
        var urlQuery = [URLQueryItem]()

        urlQuery.append(URLQueryItem.init(name: "key", value: apikey))
        if let param = configParam {
            if let components = param.components {
                let country: [String] = components.country
                var countryQuery: [String] = []
                country.forEach { (item) in
                    countryQuery.append("country:\(item)")
                }
                if countryQuery.count > 0 {
                    urlQuery.append(URLQueryItem.init(name: "components", value: countryQuery.joined(separator: "|")))
                }
                if let language = components.language {
                    urlQuery.append(URLQueryItem.init(name: "language:\(language)", value: nil))
                }
            }
            if let types = param.types {
                if  types.count > 0 {
                urlQuery.append(URLQueryItem.init(name: "types", value: types.joined(separator: "|")))
                }
            }
            if let language = param.language {
                urlQuery.append(URLQueryItem.init(name: "language", value: language))
            }
            if let query = param.query {
                if query.count >  0 {
                urlQuery.append(URLQueryItem.init(name: "query", value: query.joined(separator: "|")))
                }
            }
            if let data = param.data {
                urlQuery.append(URLQueryItem.init(name: "data", value: data))
            }
            if let extended = param.extended {
                urlQuery.append(URLQueryItem.init(name: "extended", value: extended))
            }
        }

        return urlQuery
    }
}

extension String {

    var length: Int { return self.count }

    /// Replace only first occurance of String with new String
    /// - Parameters:
    ///   - target: String to be replace
    ///   - replaceString: String to replace with
    /// - Returns: New formated string with replacement
    func stringByReplacingFirstOccurrenceOfString(target: String,
                                                  withString replaceString: String) -> String {
        if let range = self.range(of: target) {
            return self.replacingCharacters(in: range, with: replaceString)
        }
        return self
    }
    /// Remove white spaces and new lines before or after string
    /// - Returns: text without whitepaces and end or start of string
    func cleanup() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

/// Implemented wait on function call
internal class Debouncer {

    private let timeInterval: TimeInterval
    private var timer: Timer?
    typealias Handler = () -> Void
    var handler: Handler?

    /// Initialize debouncer with specific time intervel
    /// - Parameter timeInterval: in seconds
    init(timeInterval: TimeInterval) {
        self.timeInterval = timeInterval
    }

    /// Wait till next nth seconds
    public func renewInterval() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false, block: { [weak self] (timer) in
            self?.timeIntervalDidFinish(for: timer)
        })
    }

    /// Final function to call when time up
    /// - Parameter timer: Wait timer
    @objc private func timeIntervalDidFinish(for timer: Timer) {
        guard timer.isValid else {
            return
        }
        handler?()
        handler = nil
    }

}

extension Double {
    func roundToDecimal(_ fractionDigits: Int) -> Double {
        let multiplier = pow(10, Double(fractionDigits))
        return Darwin.round(self * multiplier) / multiplier
    }
}
