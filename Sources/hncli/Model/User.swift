// File:    User.swift
// Project: hncli
//
// Created by Gene De Lisa on 7/26/22
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

// For example: https://hacker-news.firebaseio.com/v0/user/jl.json?print=pretty

import Foundation

// MARK: - User

public struct User: Codable {
    public let about: String?
    public let created: Int?
    public let delay: Int?
    public let id: String?
    public let karma: Int?
    public let submitted: [Int]?

    enum CodingKeys: String, CodingKey {
        case about
        case created
        case delay
        case id
        case karma
        case submitted
    }

    public init(about: String?, created: Int?, delay: Int?, id: String?, karma: Int?, submitted: [Int]?) {
        self.about = about
        self.created = created
        self.delay = delay
        self.id = id
        self.karma = karma
        self.submitted = submitted
    }
}

// MARK: User convenience initializers and mutators

public extension User {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(User.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        about: String?? = nil,
        created: Int?? = nil,
        delay: Int?? = nil,
        id: String?? = nil,
        karma: Int?? = nil,
        submitted: [Int]?? = nil
    ) -> User {
        User(
            about: about ?? self.about,
            created: created ?? self.created,
            delay: delay ?? self.delay,
            id: id ?? self.id,
            karma: karma ?? self.karma,
            submitted: submitted ?? self.submitted
        )
    }

    func jsonData() throws -> Data {
        try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        String(data: try jsonData(), encoding: encoding)
    }
}
