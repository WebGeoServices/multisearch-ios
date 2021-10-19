//
//  WoosmapError.swift
//  Multisearch
//
//  Created by apple on 19/04/21.
//

import UIKit

/// Error Format of Multisearch SDK
public enum WoosmapError: Error {

    case Error(message: String?, statusText: String?, status: Int?)
}
extension WoosmapError {

    /// Status of error
    public var errorDescription: String? {
        switch self {
        case let .Error(_, statusText, _):
            return statusText

        }
    }

    /// Description of error
    public var localizedDescription: String? {
        switch self {
        case let .Error(message, _, _):
            return message

        }
    }

    /// Error number
    public var status: Int {
        switch self {
        case let .Error(_, _, status):
            return status ?? -1
        }
    }
}
