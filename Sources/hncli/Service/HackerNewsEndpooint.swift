// File:    File.swift
// Project:
// Package:
// Product:
//
// Created by Gene De Lisa on 7/27/22
//
// Using Swift 5.0
// Running macOS 12.4
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

//    Ask, Show and Job Stories
//    Up to 200 of the latest Ask HN, Show HN, and Job stories are at /v0/askstories, /v0/showstories, and /v0/jobstories.


struct HackerNewsEndpooint {
    public static let endpoint = "https://hacker-news.firebaseio.com/v0"
    
    
//Example: https://hacker-news.firebaseio.com/v0/maxitem.json?print=pretty
    
    static func buildIMaxtemRequest() throws -> URLRequest {
        guard let requestUrl = URL(string: "\(endpoint)/maxitem.json") else {
            throw HackerNewsAPIError.invalidURL(reason: "Could not create request url")
        }
        Logger.service.debug("max GET request url: \(requestUrl, privacy: .public)")
        return buildGETURLRequest(requestUrl: requestUrl)
    }
    
    static func buildItemRequest(kind: ItemKind) throws -> URLRequest {
        guard let requestUrl = URL(string: "\(endpoint)/\(kind.rawValue).json") else {
            throw HackerNewsAPIError.invalidURL(reason: "Could not create request url")
        }
        return buildGETURLRequest(requestUrl: requestUrl)
    }
    
    static func buildItemGETURLRequest(id: Int) throws -> URLRequest {
        Logger.service.trace("\(#function)")

        var uc = URLComponents()
        uc.scheme = "https"
        uc.host = "hacker-news.firebaseio.com"
        uc.path = "/v0/item/\(id).json"
        //uc.fragment

        // eg "https://hacker-news.firebaseio.com/v0/item/32186203.json")

        guard let requestUrl = uc.url else {
            throw HackerNewsAPIError.invalidURL(reason: "Could not create request url")
        }
        Logger.service.debug("story GET request url: \(requestUrl, privacy: .public)")
        return buildGETURLRequest(requestUrl: requestUrl)
    }


    static func buildUserGETURLRequest(id: String) throws -> URLRequest {
        Logger.service.trace("\(#function)")

        var uc = URLComponents()
        uc.scheme = "https"
        uc.host = "hacker-news.firebaseio.com"
        uc.path = "/v0/user/\(id).json"

        // For example: https://hacker-news.firebaseio.com/v0/user/jl.json?print=pretty

        guard let requestUrl = uc.url else {
            throw HackerNewsAPIError.invalidURL(reason: "Could not create request url")
        }

        Logger.service.debug("user request url: \(requestUrl, privacy: .public)")
        return buildGETURLRequest(requestUrl: requestUrl)
    }

    static func buildGETURLRequest(requestUrl: URL) -> URLRequest {
        var urlRequest = URLRequest(url: requestUrl)
        urlRequest.httpMethod = "GET"
        urlRequest.allHTTPHeaderFields = [
            "Accept": "application/json",
            "Content-Type": "application/json; charset=UTF-8"
        ]

        return urlRequest
    }
}

