// File:    File.swift
// Project: 
// Package: 
// Product: 
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


// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let ask = try Ask(json)

import Foundation

// MARK: - Ask
public struct Ask: Codable {
    public let by: String?
    public let descendants: Int?
    public let id: Int?
    public let kids: [Int]?
    public let score: Int?
    public let text: String?
    public let time: Int?
    public let title: String?
    public let type: String?

    enum CodingKeys: String, CodingKey {
        case by
        case descendants
        case id
        case kids
        case score
        case text
        case time
        case title
        case type
    }

    public init(by: String?, descendants: Int?, id: Int?, kids: [Int]?, score: Int?, text: String?, time: Int?, title: String?, type: String?) {
        self.by = by
        self.descendants = descendants
        self.id = id
        self.kids = kids
        self.score = score
        self.text = text
        self.time = time
        self.title = title
        self.type = type
    }
}

// MARK: Ask convenience initializers and mutators

public extension Ask {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Ask.self, from: data)
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
        by: String?? = nil,
        descendants: Int?? = nil,
        id: Int?? = nil,
        kids: [Int]?? = nil,
        score: Int?? = nil,
        text: String?? = nil,
        time: Int?? = nil,
        title: String?? = nil,
        type: String?? = nil
    ) -> Ask {
        return Ask(
            by: by ?? self.by,
            descendants: descendants ?? self.descendants,
            id: id ?? self.id,
            kids: kids ?? self.kids,
            score: score ?? self.score,
            text: text ?? self.text,
            time: time ?? self.time,
            title: title ?? self.title,
            type: type ?? self.type
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
