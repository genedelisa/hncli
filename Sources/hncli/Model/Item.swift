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

// id    The item's unique id.
// deleted    true if the item is deleted.
// type    The type of item. One of "job", "story", "comment", "poll", or "pollopt".
// by    The username of the item's author.
// time    Creation date of the item, in Unix Time.
// text    The comment, story or poll text. HTML.
// dead    true if the item is dead.
// parent    The comment's parent: either another comment or the relevant story.
// poll    The pollopt's associated poll.
// kids    The ids of the item's comments, in ranked display order.
// url    The URL of the story.
// score    The story's score, or the votes for a pollopt.
// title    The title of the story, poll or job. HTML.
// parts    A list of related pollopts, in display order.
// descendants    In the case of stories or polls, the total comment count.

// MARK: - Item
public struct Item: Codable {
    public let by: String?
    public let descendants: Int?
    public let id: Int?
    public let kids: [Int]?
    public let score: Int?
    public let time: Int?
    public let title: String?
    public let type: String?
    public let url: String?
    
    public let deleted: Bool?
    public let text: String?
    public let dead: Bool?
    public let parent: Int?
    public let poll: String?
    public let parts: [Int]?



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
        case deleted
        case text
        case dead
        case parent
        case poll
        case parts
    }

    public init(by: String?, descendants: Int?, id: Int?, kids: [Int]?,
                score: Int?, time: Int?, title: String?,
                type: String?, url: String?,
                deleted: Bool?,
                text: String?,
                dead: Bool?,
                parent: Int?,
                poll: String?,
                parts: [Int]?
    ) {
        self.by = by
        self.descendants = descendants
        self.id = id
        self.kids = kids
        self.score = score
        self.time = time
        self.title = title
        self.type = type
        self.url = url
        self.deleted = deleted
        self.text = text
        self.dead = dead
        self.parent = parent
        self.poll = poll
        self.parts = parts
    }
}

// MARK: Story convenience initializers and mutators

public extension Item {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Item.self, from: data)
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
        url: String?? = nil,
        deleted: Bool?? = nil,
        text: String?? = nil,
        dead: Bool?? = nil,
        parent: Int?? = nil,
        poll: String?? = nil,
        parts: [Int]?? = nil

    ) -> Item {
        return Item(
            by: by ?? self.by,
            descendants: descendants ?? self.descendants,
            id: id ?? self.id,
            kids: kids ?? self.kids,
            score: score ?? self.score,
            time: time ?? self.time,
            title: title ?? self.title,
            type: type ?? self.type,
            url: url ?? self.url,
            
            deleted: deleted ?? self.deleted,
            text: text ?? self.text,
            dead: dead ?? self.dead,
            parent: parent ?? self.parent,
            poll: poll ?? self.poll,
            parts: parts ?? self.parts
            
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}


// MARK: - CustomStringConvertible

extension Item: CustomStringConvertible {
    
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
        
        if let v = deleted {
            s += "deleted \(v)\n"
        }
        if let v = text {
            s += "text \(v)\n"
        }
        if let v = dead {
            s += "dead \(v)\n"
        }
        if let v = parent {
            s += "parent \(v)\n"
        }
        if let v = poll {
            s += "poll \(v)\n"
        }
        if let v = parts {
            s += "parts \(v)\n"
        }
        return s
    }
}
