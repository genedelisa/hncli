// File:    Comment.swift
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

import Foundation

// MARK: - Comment

public struct Comment: Codable {
    public let by: String?
    public let id: Int?
    public let kids: [Int]?
    public let parent: Int?
    public let text: String?
    public let time: Int?
    public let type: String?

    enum CodingKeys: String, CodingKey {
        case by
        case id
        case kids
        case parent
        case text
        case time
        case type
    }

    public init(by: String?, id: Int?, kids: [Int]?, parent: Int?, text: String?, time: Int?, type: String?) {
        self.by = by
        self.id = id
        self.kids = kids
        self.parent = parent
        self.text = text
        self.time = time
        self.type = type
    }
}

// MARK: Comment convenience initializers and mutators

public extension Comment {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Comment.self, from: data)
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
        id: Int?? = nil,
        kids: [Int]?? = nil,
        parent: Int?? = nil,
        text: String?? = nil,
        time: Int?? = nil,
        type: String?? = nil
    ) -> Comment {
        Comment(
            by: by ?? self.by,
            id: id ?? self.id,
            kids: kids ?? self.kids,
            parent: parent ?? self.parent,
            text: text ?? self.text,
            time: time ?? self.time,
            type: type ?? self.type
        )
    }

    func jsonData() throws -> Data {
        try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        String(data: try jsonData(), encoding: encoding)
    }
}
