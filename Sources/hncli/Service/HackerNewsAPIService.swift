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
import Combine
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
        
        var urlRequest = URLRequest(url: requestUrl)
        urlRequest.httpMethod = "GET"
        urlRequest.allHTTPHeaderFields = [
            "Accept": "application/json",
            "Content-Type": "application/json; charset=UTF-8"
        ]

        return urlRequest
    }
    
    static func createNewStoriesGETURLRequest() throws -> URLRequest {
            
        guard let requestUrl = URL(string: "https://hacker-news.firebaseio.com/v0/newstories.json") else {
            throw HackerNewsAPIError.invalidURL(reason: "Could not create request url")
        }
        
        var urlRequest = URLRequest(url: requestUrl)
        urlRequest.httpMethod = "GET"
        urlRequest.allHTTPHeaderFields = [
            "Accept": "application/json",
            "Content-Type": "application/json; charset=UTF-8"
        ]

        return urlRequest
    }
    
    static func createTopStoriesGETURLRequest() throws -> URLRequest {
            
        guard let requestUrl = URL(string: "https://hacker-news.firebaseio.com/v0/topstories.json") else {
            throw HackerNewsAPIError.invalidURL(reason: "Could not create request url")
        }
        
        var urlRequest = URLRequest(url: requestUrl)
        urlRequest.httpMethod = "GET"
        urlRequest.allHTTPHeaderFields = [
            "Accept": "application/json",
            "Content-Type": "application/json; charset=UTF-8"
        ]

        return urlRequest
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
        
        var urlRequest = URLRequest(url: requestUrl)
        urlRequest.httpMethod = "GET"
        urlRequest.allHTTPHeaderFields = [
            "Accept": "application/json",
            "Content-Type": "application/json; charset=UTF-8"
        ]
        
        return urlRequest
    }
    
///    Stories, comments, jobs, Ask HNs and even polls are just items.
///    They're identified by their ids, which are unique integers, and live under /v0/item/<id>.
    static func itemGETURLRequest(id: Int) throws -> URLRequest {
        
        Logger.service.trace("\(#function)")
        
        var uc = URLComponents()
        uc.scheme = "https"
        uc.host = "hacker-news.firebaseio.com"
        uc.path = "/v0/item/\(id).json"

        //comment: https://hacker-news.firebaseio.com/v0/item/2921983.json?print=pretty
        
        guard let requestUrl = uc.url else {
            throw HackerNewsAPIError.invalidURL(reason: "Could not create request url")
        }
        
        Logger.service.debug("user request url: \(requestUrl, privacy: .public)")
        
        var urlRequest = URLRequest(url: requestUrl)
        urlRequest.httpMethod = "GET"
        urlRequest.allHTTPHeaderFields = [
            "Accept": "application/json",
            "Content-Type": "application/json; charset=UTF-8"
        ]
        
        return urlRequest
    }

}


@available(iOS 14.0, *)
@available(macOS 12.0, *)
public class HackerNewsAPIService {
    let logger = Logger.service //Logger(subsystem: "com.rockhoppertech.API", category: "Service")

    public var verbose = false
    public var displayJSON = false

    
    // static let apiKey = ""
    
    public init() {
        self.logger.trace("\(#function)")
    }
    

//    New, Top and Best Stories
//
//    Up to 500 top and new stories are at /v0/topstories (also contains jobs) and /v0/newstories. Best stories are at /v0/beststories.
//
//    Example: https://hacker-news.firebaseio.com/v0/topstories.json?print=pretty
//


    func fetchNewStoryIDs() async throws -> [Int] {
        
        let urlRequest = try HackerNewsEndpooint.createNewStoriesGETURLRequest()
        
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
                self.logger.error("Error: \(error.localizedDescription, privacy: .public)")
                throw HackerNewsAPIError.decoding(reason: "Could not decode response: \(error.localizedDescription)")
            }

        } catch {
            self.logger.error("Error: \(error.localizedDescription, privacy: .public)")
            throw HackerNewsAPIError.invalidResponse(reason: "bad response \(error.localizedDescription)")
        }

    }
    
    func fetchTopStoryIDs() async throws -> [Int] {
        
        let urlRequest = try HackerNewsEndpooint.createNewStoriesGETURLRequest()

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
                self.logger.error("Error: \(error.localizedDescription, privacy: .public)")
                throw HackerNewsAPIError.decoding(reason: "Could not decode response: \(error.localizedDescription)")
            }

        } catch {
            self.logger.error("Error: \(error.localizedDescription, privacy: .public)")
            throw HackerNewsAPIError.invalidResponse(reason: "bad response \(error.localizedDescription)")
        }

    }
    
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
    
    func fetchItem(id: Int) async throws -> Item {
        self.logger.trace("\(#function)")
        
        let urlRequest = try HackerNewsEndpooint.itemGETURLRequest(id: id)
        
        Logger.service.debug("\(urlRequest)")
        
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
                self.logger.error("Error: \(error.localizedDescription, privacy: .public)")
                throw HackerNewsAPIError.decoding(reason: "Could not decode response: \(error.localizedDescription)")
            }
            
        } catch {
            self.logger.error("Error: \(error.localizedDescription, privacy: .public)")
            throw HackerNewsAPIError.invalidResponse(reason: "bad response \(error.localizedDescription)")
        }

    }
    
//    private(set) var storyIDs: [Int] = []
//    private(set) var stories: [Story] = []

//    public func fetchTopStories() async throws -> [Story] {
//
//        stories.removeAll()
//        storyIDs.removeAll()
//
//        do {
//            print("getting top story IDs")
//            self.storyIDs = try await fetchTopStoryIDs()
//
//            print("getting stories \(self.storyIDs.count)")
//            for storyID in storyIDs {
//                do {
//                    let story = try await self.fetchStory(id: storyID)
//                    self.stories.append(story)
//                } catch {
//                    print(error)
//                }
//            }
//        } catch {
//            print(error)
//        }
//
//        return stories
//    }
    
    public func fetchTopStories() async throws -> [Item] {
        var items: [Item] = []

        do {
            if verbose {
                print("getting top story IDs")
            }
            let itemIDs = try await fetchTopStoryIDs()
            items = try await self.fetchItems(itemIDs: itemIDs)
            
        } catch {
            print(error)
        }
        
        return items
    }
    
    public func fetchItems(itemIDs: [Int]) async throws -> [Item] {
        
        var items:[Item] = []
        
        if verbose {
            print("Fetching \(itemIDs.count) items")
        }
        for itemID in itemIDs {
            do {
                let item = try await self.fetchItem(id: itemID)
                items.append(item)
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

    
    
    
    
    
    
    
//    func getStories() async throws -> [Story] {
//        self.logger.trace("\(#function)")
//
//        let url = URL(string: "https://hacker-news.firebaseio.com/v0/item/32186203.json")
//        guard let requestUrl = url else {
//            throw HackerNewsAPIError.invalidURL(reason: "bad request url")
//        }
//        Logger.service.debug("GET request url: \(requestUrl, privacy: .public)")
//
//        var urlRequest = URLRequest(url: requestUrl)
//        urlRequest.httpMethod = "GET"
//        urlRequest.allHTTPHeaderFields = ["Accept": "application/json"]
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
//            guard let json = String(data: data, encoding: .utf8) else {
//               // self.logger.debug("json: \(json, privacy: .public)")
//                fatalError()
//            }
//
//            if let data = json.data(using: .utf8) {
//                let decoder = JSONDecoder()
//                decoder.dateDecodingStrategy = .iso8601
//                decoder.keyDecodingStrategy = .convertFromSnakeCase
//                do {
//                    return try decoder.decode([Story].self, from: data)
//                } catch {
//                    self.logger.error("Error: \(error.localizedDescription, privacy: .public)")
//                    throw HackerNewsAPIError.decoding(reason: "Could not decode response: \(error.localizedDescription)")
//                }
//            }
//
//            throw HackerNewsAPIError.decoding(reason: "Could not decode response")
//
//
//
//
//        } catch {
//            self.logger.error("Error: \(error.localizedDescription, privacy: .public)")
//            throw HackerNewsAPIError.invalidResponse(reason: "bad response \(error.localizedDescription)")
//        }
//
//
//
//    }


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


//    public func fetch(id: String) async throws -> Story {
//        self.logger.trace("\(#function)")
//
//
//        guard let url = try createGETUserRequest(id: id) else {
//            throw HackerNewsAPIError.invalidURL(reason: "bad url")
//        }
//
//        var urlRequest = URLRequest(url: url)
//        urlRequest.httpMethod = "GET"
//        urlRequest.allHTTPHeaderFields = ["Accept": "application/json"]
//
//        if let json = try await retrieveJSON(with: urlRequest) {
//            return try decode(json: json)
//        }
//        throw HackerNewsAPIError.apiError(reason: "Could not fetch")
//    }
    
    //Mark: Use Async/Await
//    func getPosts() async throws -> String {
//        let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!
//        let (data,_) = try await URLSession.shared.data(from: url)
//        let string = String(data: data, encoding: .utf8) ?? ""
//        return string
//    }
    
    
    
    
    
    
  
    
    
    
//    func get<T: Decodable>(generalType: T, completion: @escaping (Result<T, Error>) ) -> Void {
//
//        let task = session.dataTask(with: request){ (data, response, error) in
//
//            guard let data = data else {
////                let err = error ?? ... some default error ...
////                completion(.failure(err))
//                return
//            }
//
//            let result = Result {
//                // You know you can call `decode` with it because it's Decodable
//                try JSONDecoder().decode(T.self, from: data)
//            }
//            completion(result)
//        }
//        task.resume()
//    }

    
    
    
    

    
}


