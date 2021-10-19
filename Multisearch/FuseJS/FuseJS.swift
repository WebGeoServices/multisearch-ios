//
//  FuseJS.swift
//  Multisearch
//
//  Created by apple on 27/04/21.
//

import UIKit
import JavaScriptCore
internal class FuseJS {
    static let shared = FuseJS()
    var jsContext: JSContext?

    // Initializer access level change now
    private init() {
        initializeJS()
    }

    func initializeJS() {
        self.jsContext = JSContext(virtualMachine: JSVirtualMachine())
        // Manage console logging on iOS Side
        self.jsContext?.evaluateScript("var console = { log: function(message) { _consoleLog(message) } }")
        let consoleLog: @convention(block) (String) -> Void = { message in
            print("console.log: " + message)
        }
        self.jsContext?.setObject(unsafeBitCast(consoleLog, to: AnyObject.self), forKeyedSubscript: "_consoleLog" as (NSCopying & NSObjectProtocol))
        // Manage console logging on iOS Side
        self.jsContext?.evaluateScript(JSScript().fuseScript)
        self.jsContext?.evaluateScript(JSScript().callingScript)

    }

    public func callFuseJavaSDK(_ input: [AutocompleteResponseItem], _ searchFor: String, _ searchingCondition: Fuseparameter) -> [AutocompleteResponseItem] {
        var output: [AutocompleteResponseItem] = []
        if let javascriptHandler = self.jsContext {
            var jsList: [JSValue] = []
            input.forEach { (item) in
                jsList.append(item.jsValue(handler: javascriptHandler))
            }
            let condition = searchingCondition.jsValue(handler: javascriptHandler)

            if let functionFullname = javascriptHandler.objectForKeyedSubscript("fusecall") {
                if let returnResult: JSValue = functionFullname.call(withArguments: [jsList, searchFor, condition]) {
                    if let resultArray  = returnResult.toArray() {
                        resultArray.forEach { (item) in
                            if let result = item as? [String: Any] {
                                var refIndex = 0
                                var score: Double = 0
                                if let matchIndex = result["refIndex"] as? Int {
                                    refIndex = matchIndex
                                }
                                if let matchScore = result["score"] as? Double {
                                    score = matchScore
                                }
                                let scoreItem = input[refIndex]
                                scoreItem.score = score
                                output.append(scoreItem)
                                // print("\(refIndex)\t\(score)")
                            }

                        }
                    }
                }
            }
        }
        return output
    }

}

// MARK: - Fuseparameter
internal class Fuseparameter: Codable {
    let threshold: Double
    let includeScore, findAllMatches, ignoreLocation, ignoreFieldNorm: Bool
    let keys: [String]
    init () {
        self.threshold = 1
        self.includeScore = false
        self.findAllMatches = true
        self.ignoreLocation = false
        self.ignoreFieldNorm = false
        self.keys = []
    }
    init(threshold: Double, includeScore: Bool = true, findAllMatches: Bool = true, ignoreLocation: Bool = true, ignoreFieldNorm: Bool = true, keys: [String] = ["description"]) {
        self.threshold = threshold
        self.includeScore = includeScore
        self.findAllMatches = findAllMatches
        self.ignoreLocation = ignoreLocation
        self.ignoreFieldNorm = ignoreFieldNorm
        self.keys = keys
    }

    func jsValue(handler: JSContext) -> JSValue {
        var jsFormat: [String: Any] = [:]
        jsFormat["threshold"] = self.threshold
        jsFormat["includeScore"] = self.includeScore
        jsFormat["findAllMatches"] = self.findAllMatches
        jsFormat["ignoreLocation"] = self.ignoreLocation
        jsFormat["ignoreFieldNorm"] = self.ignoreFieldNorm
        jsFormat["keys"] = self.keys
        return JSValue.init(object: jsFormat, in: handler)
    }
}
