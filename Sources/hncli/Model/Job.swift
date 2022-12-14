// File:    Job.swift
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

// MARK: - Job

public struct Job: Codable {
    public let by: String?
    public let id: Int?
    public let score: Int?
    public let text: String?
    public let time: Int?
    public let title: String?
    public let type: String?
    public let url: String?

    enum CodingKeys: String, CodingKey {
        case by
        case id
        case score
        case text
        case time
        case title
        case type
        case url
    }

    public init(by: String?, id: Int?, score: Int?, text: String?, time: Int?, title: String?, type: String?, url: String?) {
        self.by = by
        self.id = id
        self.score = score
        self.text = text
        self.time = time
        self.title = title
        self.type = type
        self.url = url
    }
}

// MARK: Job convenience initializers and mutators

public extension Job {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Job.self, from: data)
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
        score: Int?? = nil,
        text: String?? = nil,
        time: Int?? = nil,
        title: String?? = nil,
        type: String?? = nil,
        url: String?? = nil
    ) -> Job {
        Job(
            by: by ?? self.by,
            id: id ?? self.id,
            score: score ?? self.score,
            text: text ?? self.text,
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
