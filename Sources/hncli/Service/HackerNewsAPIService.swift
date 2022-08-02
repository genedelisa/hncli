// File:    HackerNewsAPIService.swift
// Package: hncli
//
// Created by Gene De Lisa on 4/5/22
//
// Using Swift 5.6
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

//    New, Top and Best Stories
//
//    Up to 500 top and new stories are at /v0/topstories (also contains jobs) and /v0/newstories. Best stories are at /v0/beststories.
//
//    Example: https://hacker-news.firebaseio.com/v0/topstories.json?print=pretty
//


public enum ItemKind: String {
    case beststories
    case newstories
    case topstories
    case askstories
    case jobstories
    case showstories
    case maxitem
}

@available(iOS 14.0, *)
@available(macOS 12.0, *)
public class HackerNewsAPIService {
    let logger = Logger.service

    public var verbose = false
    
    public var displayJSON = false

    public init() {
        logger.trace("\(#function)")
    }
    
    func fetchIDs(kind: ItemKind) async throws -> [Int] {
        let urlRequest = try HackerNewsEndpooint.buildItemRequest(kind: kind)
        return try await fetchIDs(urlRequest: urlRequest)
    }
    
    func fetchIDs(urlRequest: URLRequest) async throws -> [Int] {
        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw HackerNewsAPIError.invalidResponse(reason: "Invalid Response")
            }

            if httpResponse.statusCode != 200 {
                throw HackerNewsAPIError.httpStatusCode(reason: "Response status code wrong",
                                                        status: httpResponse.statusCode)
            }

            let decoder = newJSONDecoder()
            do {
                let ids = try decoder.decode([Int].self, from: data)
                Logger.service.debug("Number of IDs: \(ids.count, privacy: .public)")
                return ids
            } catch {
                logger.error("Error: \(error.localizedDescription, privacy: .public)")
                throw HackerNewsAPIError.decoding(reason: "Could not decode response: \(error.localizedDescription)")
            }
        } catch {
            Logger.service.debug("\(#function)")
            // print("\(#function) \(error)")
            Logger.service.error("\(error.localizedDescription, privacy: .public)")
            throw HackerNewsAPIError.invalidResponse(reason: "Fetching IDs: \(error.localizedDescription)")
        }
    }

    public func fetchStories(kind: ItemKind, fetchLimit: Int = 500) async throws -> [Item] {
        var items: [Item] = []

        do {
            if verbose {
                print("Fetching \(kind.rawValue) story IDs")
            }
            let itemIDs = try await fetchIDs(kind: kind)
            items = try await fetchItems(itemIDs: itemIDs, fetchLimit: fetchLimit)
        } catch {
            Logger.service.error("\(#function) \(error)")
            throw HackerNewsAPIError.invalidResponse(reason: "\(error.localizedDescription)")
        }

        return items
    }
    

    public func fetchItems(itemIDs: [Int], fetchLimit: Int) async throws -> [Item] {
        var items: [Item] = []

        if verbose {
            print("Fetching \(fetchLimit) of \(itemIDs.count) items")
        }

        var index = 0
        for itemID in itemIDs {
            do {
                let item = try await fetchItem(id: itemID)
                items.append(item)

                index += 1
                if index == fetchLimit {
                    break
                }

                if verbose {
                    if let s = item.title {
                        print("\(s)\n")
                    }
                }
            } catch {
                print(error)
            }
        }
        return items
    }
    
    func fetchItem(id: Int) async throws -> Item {
        logger.trace("\(#function)")

        let urlRequest = try HackerNewsEndpooint.buildItemGETURLRequest(id: id)   //.itemGETURLRequest(id: id)

        Logger.service.debug("\(urlRequest, privacy: .public)")

        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw HackerNewsAPIError.invalidResponse(reason: "Invalid Response; not an HTTP Response")
            }

            if httpResponse.statusCode != 200 {
                throw HackerNewsAPIError.httpStatusCode(reason: "Non successful HTTP Response",
                                                        status: httpResponse.statusCode)
            }

            if displayJSON, let s = String(data: data, encoding: .utf8) {
                Logger.service.debug("\(s, privacy: .public)")
                print("\(s)\n")
            }

            do {
                let decoder = newJSONDecoder()
                return try decoder.decode(Item.self, from: data)
            } catch let DecodingError.dataCorrupted(context) {
                print("Decoding Error. The data is corrupted.")
                print("\(context.debugDescription)")
                print("Coding Path:")
                for path in context.codingPath {
                    print(" \(path)")
                }
                if let underlying = context.underlyingError {
                    print("\(underlying.localizedDescription)")
                    print("Underlying error: \n\(underlying)")
                }

                throw HackerNewsAPIError.decoding(reason: "")
            } catch let DecodingError.keyNotFound(key, context) {
                print("Decoding Error. The key '\(key)' is not found.")
                print(context.debugDescription)
                print("Coding Path:")
                for path in context.codingPath {
                    print(" \(path)")
                }
                if let underlying = context.underlyingError {
                    print("\(underlying.localizedDescription)")
                    print("Underlying error: \n\(underlying)")
                }
                throw HackerNewsAPIError.decoding(reason: "Key not found")
            } catch let DecodingError.valueNotFound(value, context) {
                print("Decoding Error. The value '\(value)' is not found.")
                print("Value '\(value)' not found:", context.debugDescription)
                print("Coding Path:")
                for path in context.codingPath {
                    print(" \(path)")
                }
                if let underlying = context.underlyingError {
                    print("\(underlying.localizedDescription)")
                    print("Underlying error: \n\(underlying)")
                }
                throw HackerNewsAPIError.decoding(reason: "Value not found")
            } catch let DecodingError.typeMismatch(type, context) {
                print("Decoding Error. The type '\(type)' mismatch.")
                print("Type '\(type)' mismatch:", context.debugDescription)
                print("Coding Path:")
                for path in context.codingPath {
                    print(" \(path)")
                }
                if let underlying = context.underlyingError {
                    print("\(underlying.localizedDescription)")
                    print("Underlying error: \n\(underlying)")
                }
                throw HackerNewsAPIError.decoding(reason: "Type mismatch")
            } catch {
                logger.error("Error: \(error.localizedDescription, privacy: .public)")
                throw HackerNewsAPIError.decoding(reason: "Could not decode response: \(error.localizedDescription)")
            }
        } catch {
            Logger.service.error("Error: \(error.localizedDescription, privacy: .public)")
            throw HackerNewsAPIError.invalidResponse(reason: "Fetching item: \(error.localizedDescription)")
        }
    }

}









//    func makePOSTUserRequest(post: Post) async throws -> Story {
//        self.logger.trace("\(#function)")
//
//        let url = URL(string: "https://jsonplaceholder.typicode.com/posts")
//        guard let requestUrl = url else {
//            throw APIError.invalidURL(reason: "bad request url")
//        }
//
//        var request = URLRequest(url: requestUrl)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Accept")
//        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
//        let jsonData = try JSONEncoder().encode(post)
//        request.httpBody = jsonData
//
//        Logger.service.debug("post POST request url: \(requestUrl, privacy: .public)")
//
//        do {
//            let (data, response) = try await URLSession.shared.data(for: request)
//
//            guard let httpResponse = response as? HTTPURLResponse else {
//                throw APIError.invalidResponse(reason: "Invalid Response")
//            }
//
//            if httpResponse.statusCode == 429 {
//                throw APIError.rateLimitted(reason: "Rate Limited")
//            }
//
//            if httpResponse.statusCode == 503 {
//                throw APIError.serverBusy(reason: "Server Busy")
//            }
//
//            // 201 is created - which is what we want here!
//            if httpResponse.statusCode != 201 {
//                throw APIError.httpStatusCode(reason: "Response is not good \(httpResponse.statusCode)",
//                                          status: httpResponse.statusCode)
//            }
//
//            let responsePost = try Post(data: data)
//            if let json = String(data: data, encoding: .utf8) {
//                self.logger.debug("json response: \(json, privacy: .public)")
//               // return json
//            }
//
//            return responsePost
//
//        } catch {
//            self.logger.error("Error: \(error.localizedDescription, privacy: .public)")
//            throw APIError.invalidResponse(reason: "bad response \(error.localizedDescription)")
//        }
//
//    }

   
//    func fetchStory(id: Int) async throws -> Story {
//        self.logger.trace("\(#function)")
//
//        let urlRequest = try HackerNewsEndpooint.createStoryGETURLRequest(id: id)
//
//        Logger.service.debug("\(urlRequest)")
//
//        do {
//            let (data, response) = try await URLSession.shared.data(for: urlRequest)
//
//            guard let httpResponse = response as? HTTPURLResponse else {
//                throw HackerNewsAPIError.invalidResponse(reason: "Invalid Response")
//            }
//
//            if httpResponse.statusCode != 200 {
//                throw HackerNewsAPIError.httpStatusCode(reason: "Response is not good", status: httpResponse.statusCode)
//            }
//
//            //if let s = String(data: data, encoding: .utf8) {
//                //Logger.service.debug("json: \(s, privacy: .public)")
//                //print("json: \(s)")
//            //}
//
//            do {
//                let decoder = newJSONDecoder()
//                return try decoder.decode(Story.self, from: data)
//
//            } catch let DecodingError.dataCorrupted(context) {
//                print("Decoding Error. The data is corrupted.")
//                print("\(context.debugDescription)")
//                print("Coding Path:")
//                for path in context.codingPath {
//                    print(" \(path)")
//                }
//                if let underlying = context.underlyingError {
//                    print("\(underlying.localizedDescription)")
//                    print("Underlying error: \n\(underlying)")
//                }
//
//                throw HackerNewsAPIError.decoding(reason: "")
//
//
//            } catch let DecodingError.keyNotFound(key, context) {
//                print("Decoding Error. The key '\(key)' is not found.")
//                print(context.debugDescription)
//                print("Coding Path:")
//                for path in context.codingPath {
//                    print(" \(path)")
//                }
//                if let underlying = context.underlyingError {
//                    print("\(underlying.localizedDescription)")
//                    print("Underlying error: \n\(underlying)")
//                }
//                throw HackerNewsAPIError.decoding(reason: "")
//            } catch let DecodingError.valueNotFound(value, context) {
//                print("Decoding Error. The value '\(value)' is not found.")
//                print("Value '\(value)' not found:", context.debugDescription)
//                print("Coding Path:")
//                for path in context.codingPath {
//                    print(" \(path)")
//                }
//                if let underlying = context.underlyingError {
//                    print("\(underlying.localizedDescription)")
//                    print("Underlying error: \n\(underlying)")
//                }
//                throw HackerNewsAPIError.decoding(reason: "")
//            } catch let DecodingError.typeMismatch(type, context) {
//                print("Decoding Error. The type '\(type)' mismatch.")
//                print("Type '\(type)' mismatch:", context.debugDescription)
//                print("Coding Path:")
//                for path in context.codingPath {
//                    print(" \(path)")
//                }
//                if let underlying = context.underlyingError {
//                    print("\(underlying.localizedDescription)")
//                    print("Underlying error: \n\(underlying)")
//                }
//                throw HackerNewsAPIError.decoding(reason: "")
//
//            } catch {
//                self.logger.error("Error: \(error.localizedDescription, privacy: .public)")
//                throw HackerNewsAPIError.decoding(reason: "Could not decode response: \(error.localizedDescription)")
//            }
//
//        } catch {
//            self.logger.error("Error: \(error.localizedDescription, privacy: .public)")
//            throw HackerNewsAPIError.invalidResponse(reason: "bad response \(error.localizedDescription)")
//        }
//
//    }


// public func fetchNewStories(_ fetchLimit: Int = 500) async throws -> [Item] {
//        var items: [Item] = []
//
//        do {
//            if verbose {
//                print("Fetching new story IDs")
//            }
//            let itemIDs = try await fetchNewStoryIDs()
//            items = try await fetchItems(itemIDs: itemIDs, fetchLimit: fetchLimit)
//        } catch {
//            Logger.service.error("\(#function) \(error)")
//            throw HackerNewsAPIError.invalidResponse(reason: "\(error.localizedDescription)")
//        }
//
//        return items
//    }
//
//    public func fetchBestStories(_ fetchLimit: Int = 500) async throws -> [Item] {
//        var items: [Item] = []
//
//        do {
//            if verbose {
//                print("Fetching best story IDs")
//            }
//            let itemIDs = try await fetchBestStoryIDs()
//            items = try await fetchItems(itemIDs: itemIDs, fetchLimit: fetchLimit)
//        } catch {
//            Logger.service.error("\(#function) \(error)")
//            throw HackerNewsAPIError.invalidResponse(reason: "\(error.localizedDescription)")
//        }
//
//        return items
//    }
//
//    public func fetchTopStories(_ fetchLimit: Int = 500) async throws -> [Item] {
//        var items: [Item] = []
//
//        do {
//            if verbose {
//                print("Fetching top story IDs")
//            }
//            let itemIDs = try await fetchTopStoryIDs()
//            items = try await fetchItems(itemIDs: itemIDs, fetchLimit: fetchLimit)
//        } catch {
//            Logger.service.error("\(#function) \(error)")
//            throw HackerNewsAPIError.invalidResponse(reason: "\(error.localizedDescription)")
//        }
//
//        return items
//    }
//    func fetchNewStoryIDs() async throws -> [Int] {
//        let urlRequest = try HackerNewsEndpooint.createNewStoriesGETURLRequest()
//        return try await fetchIDs(urlRequest: urlRequest)
//    }
//
//    func fetchTopStoryIDs() async throws -> [Int] {
//        let urlRequest = try HackerNewsEndpooint.createNewStoriesGETURLRequest()
//        return try await fetchIDs(urlRequest: urlRequest)
//    }
//
//    func fetchBestStoryIDs() async throws -> [Int] {
//        let urlRequest = try HackerNewsEndpooint.createBestStoriesGETURLRequest()
//        return try await fetchIDs(urlRequest: urlRequest)
//    }
//
//    // Ask HN, Show HN, and Job stories
//    func fetchAskStoryIDs() async throws -> [Int] {
//        let urlRequest = try HackerNewsEndpooint.createAskIDsGETURLRequest()
//        return try await fetchIDs(urlRequest: urlRequest)
//    }
//
//    func fetchShowStoryIDs() async throws -> [Int] {
//        let urlRequest = try HackerNewsEndpooint.createShowIDsGETURLRequest()
//        return try await fetchIDs(urlRequest: urlRequest)
//    }
//
//    func fetchJobStoryIDs() async throws -> [Int] {
//        let urlRequest = try HackerNewsEndpooint.createJobIDsGETURLRequest()
//        return try await fetchIDs(urlRequest: urlRequest)
//    }
