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
// import Combine
import os.log

struct HackerNewsEndpooint {
    
    static func createStoryGETURLRequest(id: Int) throws -> URLRequest {
        Logger.service.trace("\(#function)")
        
        var uc = URLComponents()
        uc.scheme = "https"
        uc.host = "hacker-news.firebaseio.com"
        uc.path = "/v0/item/\(id).json"
        
        // eg "https://hacker-news.firebaseio.com/v0/item/32186203.json")
        
        guard let requestUrl = uc.url else {
            throw HackerNewsAPIError.invalidURL(reason: "Could not create request url")
        }
        Logger.service.debug("story GET request url: \(requestUrl, privacy: .public)")
        return createGETURLRequest(requestUrl: requestUrl)
        
        //        var urlRequest = URLRequest(url: requestUrl)
        //        urlRequest.httpMethod = "GET"
        //        urlRequest.allHTTPHeaderFields = [
        //            "Accept": "application/json",
        //            "Content-Type": "application/json; charset=UTF-8"
        //        ]
        //
        //        return urlRequest
    }
    
    static func createNewStoriesGETURLRequest() throws -> URLRequest {
        
        guard let requestUrl = URL(string: "https://hacker-news.firebaseio.com/v0/newstories.json") else {
            throw HackerNewsAPIError.invalidURL(reason: "Could not create request url")
        }
        return createGETURLRequest(requestUrl: requestUrl)
        //
        //
        //        var urlRequest = URLRequest(url: requestUrl)
        //        urlRequest.httpMethod = "GET"
        //        urlRequest.allHTTPHeaderFields = [
        //            "Accept": "application/json",
        //            "Content-Type": "application/json; charset=UTF-8"
        //        ]
        //
        //        return urlRequest
    }
    
    static func createBestStoriesGETURLRequest() throws -> URLRequest {
        
        guard let requestUrl = URL(string: "https://hacker-news.firebaseio.com/v0/beststories.json") else {
            throw HackerNewsAPIError.invalidURL(reason: "Could not create request url")
        }
        return createGETURLRequest(requestUrl: requestUrl)
    }
    
    
    static func createTopStoriesGETURLRequest() throws -> URLRequest {
        
        guard let requestUrl = URL(string: "https://hacker-news.firebaseio.com/v0/topstories.json") else {
            throw HackerNewsAPIError.invalidURL(reason: "Could not create request url")
        }
        
        return createGETURLRequest(requestUrl: requestUrl)
        
        //        var urlRequest = URLRequest(url: requestUrl)
        //        urlRequest.httpMethod = "GET"
        //        urlRequest.allHTTPHeaderFields = [
        //            "Accept": "application/json",
        //            "Content-Type": "application/json; charset=UTF-8"
        //        ]
        //
        //        return urlRequest
    }
    
    static func userGETURLRequest(id: String) throws -> URLRequest {
        
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
        return createGETURLRequest(requestUrl: requestUrl)
        
        //        var urlRequest = URLRequest(url: requestUrl)
        //        urlRequest.httpMethod = "GET"
        //        urlRequest.allHTTPHeaderFields = [
        //            "Accept": "application/json",
        //            "Content-Type": "application/json; charset=UTF-8"
        //        ]
        //
        //        return urlRequest
    }
    
    ///    Stories, comments, jobs, Ask HNs and even polls are just items.
    ///    They're identified by their ids, which are unique integers, and live under /v0/item/<id>.
    static func itemGETURLRequest(id: Int) throws -> URLRequest {
        
        Logger.service.trace("\(#function)")
        
        var uc = URLComponents()
        uc.scheme = "https"
        uc.host = "hacker-news.firebaseio.com"
        uc.path = "/v0/item/\(id).json"
        
        // comment: https://hacker-news.firebaseio.com/v0/item/2921983.json?print=pretty
        
        guard let requestUrl = uc.url else {
            throw HackerNewsAPIError.invalidURL(reason: "Could not create request url")
        }
        
        Logger.service.debug("user request url: \(requestUrl, privacy: .public)")
        
        return createGETURLRequest(requestUrl: requestUrl)
        
        //        var urlRequest = URLRequest(url: requestUrl)
        //        urlRequest.httpMethod = "GET"
        //        urlRequest.allHTTPHeaderFields = [
        //            "Accept": "application/json",
        //            "Content-Type": "application/json; charset=UTF-8"
        //        ]
        //
        //        return urlRequest
    }
    
    static func createGETURLRequest(requestUrl: URL) -> URLRequest {
        var urlRequest = URLRequest(url: requestUrl)
        urlRequest.httpMethod = "GET"
        urlRequest.allHTTPHeaderFields = [
            "Accept": "application/json",
            "Content-Type": "application/json; charset=UTF-8"
        ]
        
        return urlRequest
    }
    
}
