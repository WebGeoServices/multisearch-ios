//
//  SearchResult.swift
//  Multisearch
//
//  Created by apple on 26/04/21.
//

import UIKit
import JavaScriptCore

/// Formatted search result in this class structure
public class AutocompleteResponseItem {

    /// Score calculated from scoring routine. If scoring routine is not called, score will return null value
    public var score: Double?

    /// Contains the human-readable name for the returned result
    public let description: String

    /// Type: 'localities'|'address'|'store'|'places'
    /// The api the result was retrieved from
    public let api: SearchProviderType

    /// Location info in key:value format
    public let input: [String: Any]

    /// Structure of data in JSON String format
    public var jsonStructure: String? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: input, options: .prettyPrinted)
            return String(data: jsonData, encoding: .utf8)
        } catch let error {
            print(error.localizedDescription)
        }
        return nil
    }

    /// Data Identifier
    public var id: String? {
        if let match = input["public_id"] as? String {
            return match
        }
        if let match = input["place_id"] as? String {
            return match
        }
        if let match = input["store_id"] as? String {
            return match
        }
        return nil
    }

    /// Array of types that apply to this item.
    public var types: [String]? {
        if let match = input["type"] as? String {
            return [match]
        }
        if let match = input["types"] as? [String] {
            return match
        }
        return nil
    }

    /// Contains an array with offset value and length. These describe the location of the entered term in the prediction result text, so that the term can be highlighted if desired.
    public var matchedSubstrings: [NSRange]? {
        if let match = input["matched_substrings"] as? [String: Any] {
            if let descriptions  = match["description"] as? [[String: Int64]] {
                var matchFormat: [NSRange] = []
                descriptions.forEach { (matchLocation) in
                    let length: Int = Int.init(exactly: matchLocation["length"] ?? 0) ?? 0
                    let offset: Int = Int.init(exactly: matchLocation["offset"] ?? 0) ?? 0
                    matchFormat.append(NSRange.init(location: offset, length: length))
                }
                return matchFormat
            }
        }
        if let match = input["matched_substring"] as? [String: Any] {
            if let descriptions  = match["description"] as? [[String: Int64]] {
                var matchFormat: [NSRange] = []
                descriptions.forEach { (matchLocation) in
                    let length: Int = Int.init(exactly: matchLocation["length"] ?? 0) ?? 0
                    let offset: Int = Int.init(exactly: matchLocation["offset"] ?? 0) ?? 0
                    matchFormat.append(NSRange.init(location: offset, length: length))
                }
                return matchFormat
            }
        }
        // If first format is not matching, then check with this format. Google places returns in this format
        if let match = input["matched_substrings"] as? [[String: Int64]] {
            var matchFormat: [NSRange] = []
            match.forEach { (matchLocation) in
                let length: Int = Int.init(exactly: matchLocation["length"] ?? 0) ?? 0
                let offset: Int = Int.init(exactly: matchLocation["offset"] ?? 0) ?? 0
                matchFormat.append(NSRange.init(location: offset, length: length))
            }
            return matchFormat
        }
        return nil
    }

    /// HTML description in which the entered term in the prediction result text are in &lt;mark&gt;&lt;/mark&gt; tags
    public var highlight: String {
        var output: String = description
        var matchlength = 0
        var matchoffset = 0

        if let match = matchedSubstrings {
            match.forEach { (matchInfo) in
                matchlength = matchInfo.length
                matchoffset = matchInfo.location
                let start: String.Index = description.index(description.startIndex, offsetBy: matchoffset)
                let end = description.index(description.startIndex, offsetBy: matchoffset+matchlength)
                let stringRange = start..<end
                let marchWord: String = String(description[stringRange])
                output = output.stringByReplacingFirstOccurrenceOfString(target: marchWord, withString: "<mark>\(marchWord)</mark>")
            }
        }
        return output
    }

    /// Structure of data in JSON String format
    func jsValue(handler: JSContext) -> JSValue {
        var jsFormat: [String: Any] = [:]
        jsFormat["description"] = self.description
        if let id = self.id {
            jsFormat["id"] = id
        }
        jsFormat["highlight"] = self.highlight
        return JSValue.init(object: jsFormat, in: handler)
    }

    /// Search result format
    /// - Parameters:
    ///   - description: Detail of address
    ///   - searchtype: Type of address
    ///   - input: Custome data format of address
    internal init(description: String, searchtype: SearchProviderType, input: [String: Any] ) {
        self.description = description
        self.api = searchtype
        self.input = input
    }

}
