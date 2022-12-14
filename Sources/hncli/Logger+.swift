// File:    Logger+
// Project: hncli
//
// Created by Gene De Lisa on 6/13/22
//
// Using Swift 5.0
// Running macOS 12.4
// Github: https://github.com/genedelisa/hncli
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
import OSLog

@available(macOS 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
public extension OSLog {
    static var subsystem: String = {
        if let s = Bundle.main.bundleIdentifier {
            return s
        }
        if let s = Bundle.module.bundleIdentifier {
            return s
        }
        return "com.rockhoppertech.hncli"
    }()

    static let general = OSLog(subsystem: subsystem, category: "General")
    static let domain = OSLog(subsystem: subsystem, category: "Domain")
    static let model = OSLog(subsystem: subsystem, category: "Model")
    static let service = OSLog(subsystem: subsystem, category: "Service")
    static let api = OSLog(subsystem: subsystem, category: "API")
    static let persistence = OSLog(subsystem: subsystem, category: "Persistence")
    static let parsing = OSLog(subsystem: subsystem, category: "Parsing")
    static let ui = OSLog(subsystem: subsystem, category: "UI")
    static let error = OSLog(subsystem: subsystem, category: "Error")
    static let testing = OSLog(subsystem: subsystem, category: "Testing")
    static let command = OSLog(subsystem: subsystem, category: "Command")
}

@available(macOS 11.0, iOS 14.0, watchOS 7.0, tvOS 14.0, *)
public extension Logger {
    static let general = Logger(OSLog.general)
    static let domain = Logger(OSLog.domain)
    static let model = Logger(OSLog.model)
    static let service = Logger(OSLog.service)
    static let api = Logger(OSLog.api)
    static let persistence = Logger(OSLog.persistence)
    static let parsing = Logger(OSLog.parsing)
    static let ui = Logger(OSLog.ui)
    static let error = Logger(OSLog.error)
    static let testing = Logger(OSLog.testing)
    static let command = Logger(OSLog.command)
}

@available(macOS 10.15, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
extension Logger {
    static func exportEntries(subsystem: String, category: String? = nil, date: Date? = nil) -> [String] {
        var entries: [String] = []

        do {
            let store: OSLogStore
            var position: OSLogPosition
            if let date = date {
                // if you want log entries from previous runs
                store = try OSLogStore(scope: .system)
                position = store.position(date: date)
            } else {
                // entries from just the current process
                store = try OSLogStore(scope: .currentProcessIdentifier)
                position = store.position(timeIntervalSinceLatestBoot: 1)
            }

            // command line help for predicates
            // log help predicates
            var predicate: NSPredicate
            if let category = category {
                let subsystemPredicate = NSPredicate(format: "(subsystem == %@)", subsystem)
                let categoryPredicate = NSPredicate(format: "(category == %@)", category)
                predicate = NSCompoundPredicate(andPredicateWithSubpredicates:
                    [subsystemPredicate, categoryPredicate])
            } else {
                predicate = NSPredicate(format: "(subsystem == %@)", subsystem)
            }

            entries = try store
                .getEntries(at: position, matching: predicate)
                .compactMap { $0 as? OSLogEntryLog }
                .map { "[\($0.date.formatted())] [\($0.category)] \($0.composedMessage)" }
        } catch {
            Logger.error.warning("\(error.localizedDescription, privacy: .public)")
        }

        return entries
    }

    static func findEntries(subsystem: String, category: String? = nil, date: Date? = nil) -> [OSLogEntryLog] {
        var entries: [OSLogEntryLog] = []

        do {
            let store: OSLogStore
            var position: OSLogPosition
            if let date = date {
                // if you want log entries from previous runs
                store = try OSLogStore(scope: .system)
                position = store.position(date: date)
            } else {
                // entries from just the current process
                store = try OSLogStore(scope: .currentProcessIdentifier)
                position = store.position(timeIntervalSinceLatestBoot: 1)
            }

            // command line help for predicates:
            // log help predicates
            var predicate: NSPredicate
            if let category = category {
                let subsystemPredicate = NSPredicate(format: "(subsystem == %@)", subsystem)
                let categoryPredicate = NSPredicate(format: "(category == %@)", category)
                predicate = NSCompoundPredicate(andPredicateWithSubpredicates:
                    [subsystemPredicate, categoryPredicate])
            } else {
                predicate = NSPredicate(format: "(subsystem == %@)", subsystem)
            }

            // getEntries returns a colleciton of OSLogEntry.
            // So compactMap will downcast to OSLogEntryLog is it really is an OSLogEntryLog.
            entries = try store
                .getEntries(at: position, matching: predicate)
                .compactMap { $0 as? OSLogEntryLog }
        } catch {
            Logger.error.warning("\(error.localizedDescription, privacy: .public)")
        }

        return entries
    }
}

extension DefaultStringInterpolation {
    mutating func appendInterpolation<T: OSLogEntryLog>(_ entry: T) {
        var levelString = ""
        switch entry.level {
        case .error:
            levelString = "error"
        case .undefined:
            levelString = "undefined"
        case .debug:
            levelString = "debug"
        case .info:
            levelString = "info"
        case .notice:
            levelString = "notice"
        case .fault:
            levelString = "fault"
        @unknown default:
            levelString = "unknown"
        }

        let isoDateFormatter = ISO8601DateFormatter()
//        isoDateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        isoDateFormatter.timeZone = TimeZone.current
        isoDateFormatter.formatOptions = [
            .withFullDate,
            .withFullTime,
            .withDashSeparatorInDate,
            .withFractionalSeconds
        ]

        let isoDate = isoDateFormatter.string(from: entry.date)

        // compact   Compact human readable output.  ISO-8601 date (millisecond precision),
        // abbreviated log type, process, processID, thread ID, subsystem, category and
        // message content.

        // let category = entry.category.padding(toLength: 13, withPad: " ", startingAt: 0)

        let subsyscat = "\(entry.subsystem):\(entry.category)".padding(toLength: 42, withPad: " ", startingAt: 0)

        var s = ""
//        s += "[\(entry.date.formatted())] "
//        s += "[\(entry.date.ISO8601Format())]) "
        s += "[\(isoDate)] "
        // log type?
        s += "\(entry.process)[\(entry.processIdentifier):\(entry.threadIdentifier)] "
        s += "[\(levelString)] " // not in compact
//        s += "[\(entry.subsystem)] "
//        s += "[\(category)] "
        s += "[\(subsyscat)] "
        s += "\(entry.composedMessage) "
        appendInterpolation(s)
    }
}

// extension OSLogEntryLog: CustomStringConvertible {
//
//    public override var description: String {
//        var s = ""
//        var levelString = ""
//        switch level {
//        case .error:
//            levelString = "error"
//        case .undefined:
//            levelString = "undefined"
//        case .debug:
//            levelString = "debug"
//        case .info:
//            levelString = "info"
//        case .notice:
//            levelString = "notice"
//        case .fault:
//            levelString = "fault"
//        @unknown default:
//            levelString = "unknown"
//        }
//
//
//        s += "[\(date.formatted())] "
//        s += "[\(category)] "
//        s += "[\(category)] "
//        s += "[\(levelString)] "
//        s += "\(composedMessage) "
//
//        return s
//    }
// }
