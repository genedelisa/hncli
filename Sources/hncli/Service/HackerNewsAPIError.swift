// File:    HackerNewsAPIError.swift
// Package: hncli
//
// Created by Gene De Lisa on 4/5/22
//
// Using Swift 5.0
// Running macOS 12.3
// Github: https://github.com/genedelisa/
// Product: https://rockhoppertech.com/
//
// Follow me on Twitter: @GeneDeLisaDev
//
// Licensed under the MIT License (the "License");
//
// You may not use this file except in compliance with the License.
//
// You may obtain a copy of the License at
//
// https://opensource.org/licenses/MIT

import Foundation
import os.log

public enum HackerNewsAPIError: Error {
    case apiError(reason: String)
    case post(reason: String)
    case badPacket(reason: String)
    case encoding(reason: String)
    case decoding(reason: String)

    case httpStatusCode(reason: String, status: Int)
    case invalidResponse(reason: String)
    case invalidURL(reason: String)
    case rateLimitted(reason: String)
    case serverBusy(reason: String)
}

extension HackerNewsAPIError: CustomStringConvertible {
    public var description: String {
        switch self {
        case let .post(reason: reason):
            return "\(reason)"
        case let .badPacket(reason: reason):
            return "\(reason)"
        case let .apiError(reason: reason):
            return "\(reason)"
        case let .invalidResponse(reason: reason):
            return "\(reason)"
        case let .invalidURL(reason: reason):
            return "\(reason)"
        case let .rateLimitted(reason: reason):
            return "\(reason)"
        case let .serverBusy(reason: reason):
            return "\(reason)"
        case let .decoding(reason: reason):
            return "\(reason)"
        case let .encoding(reason: reason):
            return "\(reason)"

        case let .httpStatusCode(reason: reason, status: status):
            return "\(reason) status: \(status)"
        }
    }
}

extension HackerNewsAPIError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case let .badPacket(localizedError):
            return NSLocalizedString(localizedError,
                                     comment: "My error")

        case let .httpStatusCode(reason: reason, status: status):
            return NSLocalizedString(reason,
                                     comment: "My error \(status)")

        case let .post(reason: reason):
            return NSLocalizedString(reason,
                                     comment: "My error \(reason)")
        case let .apiError(reason: reason):
            return NSLocalizedString(reason,
                                     comment: "My error \(reason)")

        case let .invalidResponse(reason: reason):
            return NSLocalizedString(reason,
                                     comment: "My error \(reason)")

        case let .invalidURL(reason: reason):
            return NSLocalizedString(reason,
                                     comment: "My error \(reason)")

        case let .rateLimitted(reason: reason):
            return NSLocalizedString(reason,
                                     comment: "My error \(reason)")

        case let .serverBusy(reason: reason):
            return NSLocalizedString(reason,
                                     comment: "My error \(reason)")
        case let .decoding(reason: reason):
            return NSLocalizedString(reason,
                                     comment: "My error \(reason)")
        case let .encoding(reason: reason):
            return NSLocalizedString(reason,
                                     comment: "My error \(reason)")
        }
    }

    public var failureReason: String? {
        switch self {
        default:
            return NSLocalizedString("You messed up!",
                                     comment: "No comment at this time")
        }
    }

    //    public var recoverySuggestion: String? {
    //        switch self {
    //        case .badPacket:
    //            return NSLocalizedString("Plug it in.", comment: "")
    //        }
    //    }
    //    public var helpAnchor: String? {
    //        switch self {
    //        case .badPacket:
    //            return NSLocalizedString("someHelpAnchor.", comment: "")
    //        }
    //    }
}
