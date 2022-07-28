// File:    Story.swift
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

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let story = try Story(json)

import Foundation

// MARK: - Story

public struct Story: Codable {
    public let by: String?
    public let descendants: Int?
    public let id: Int?
    public let kids: [Int]?
    public let score: Int?
    public let time: Int?
    public let title: String?
    public let type: String?
    public let url: String?

    enum CodingKeys: String, CodingKey {
        case by
        case descendants
        case id
        case kids
        case score
        case time
        case title
        case type
        case url
    }

    public init(by: String?, descendants: Int?, id: Int?, kids: [Int]?, score: Int?, time: Int?, title: String?, type: String?, url: String?) {
        self.by = by
        self.descendants = descendants
        self.id = id
        self.kids = kids
        self.score = score
        self.time = time
        self.title = title
        self.type = type
        self.url = url
    }
}

// MARK: Story convenience initializers and mutators

public extension Story {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Story.self, from: data)
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
        time: Int?? = nil,
        title: String?? = nil,
        type: String?? = nil,
        url: String?? = nil
    ) -> Story {
        Story(
            by: by ?? self.by,
            descendants: descendants ?? self.descendants,
            id: id ?? self.id,
            kids: kids ?? self.kids,
            score: score ?? self.score,
            time: time ?? self.time,
            title: title ?? self.title,
            type: type ?? self.type,
            url: url ?? self.url
        )
    }

    func jsonData() throws -> Data {
        try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        String(data: try jsonData(), encoding: encoding)
    }
}

// MARK: - CustomStringConvertible

extension Story: CustomStringConvertible {
    public var description: String {
        var s = "\(Swift.type(of: self))\n"

        if let v = title {
            s += "title \(v)\n"
        }
        if let v = by {
            s += "by \(v)\n"
        }
        if let v = id {
            s += "id \(v)\n"
        }
        if let v = descendants {
            s += "descendants \(v)\n"
        }
        if let v = kids {
            s += "kids \(v)\n"
        }
        if let v = score {
            s += "score \(v)\n"
        }
        if let v = time {
            s += "time \(v)\n"

            let t = Date(timeIntervalSince1970: Double(v))
            let dateFormat: DateFormatter = {
                let dateFormat = DateFormatter()
                dateFormat.dateStyle = .medium
                dateFormat.timeStyle = .medium
                dateFormat.timeZone = TimeZone.current
                return dateFormat
            }()
            s += "time \(dateFormat.string(from: t))\n"
        }
        if let v = url {
            s += "url \(v)\n"
        }

        return s
    }
}
