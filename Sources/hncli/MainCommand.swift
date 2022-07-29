// File:    MainCommand.swift
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

// @see https://apple.github.io/swift-argument-parser/documentation/argumentparser

import ArgumentParser
import Foundation
import GDTerminalColor
import os.log
import OSLog

@available(macOS 10.15, *)
@main
struct MainCommand: AsyncParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "hncli ",
        abstract: "Hacker news frobs",
        usage: "e.g. xcrun swift run hncli --display-brief --fetch-limit 5 --new",
        version: "0.0.1"
    )

    enum SearchType: String, EnumerableFlag, Codable {
        case best
        case new
        case top
    }

    @Flag(exclusivity: .exclusive,
          help: ArgumentHelp(NSLocalizedString("Choose type of search.", comment: "")))
    var searchType: SearchType

    @Flag(name: .shortAndLong,
          help: ArgumentHelp(NSLocalizedString("Yakity yak.", comment: "")))
    var verbose = false

    @Flag(
        help: ArgumentHelp(NSLocalizedString("Display the help document.", comment: ""),
                           discussion: "This will print the help file to stdout")
    )
    var prolixHelp = false

    @Flag(
        help: ArgumentHelp(NSLocalizedString("Display the JSON response.", comment: ""),
                           discussion: "This will print the JSON returned from the server")
    )
    var displayJSON = false

    @Flag(
        help: ArgumentHelp(NSLocalizedString("Display the items briefly .", comment: ""),
                           discussion: "This will print just the title and url of the item")
    )
    var displayBrief = false

    @Option(name: .shortAndLong,
            help: ArgumentHelp(NSLocalizedString("Number of items to fetch.", comment: ""),
                               discussion: "This will fetch only this number of items regardless of the number of IDs"))
    var fetchLimit: Int = 500

    @Flag(help: ArgumentHelp(NSLocalizedString("Display the log entries for debugging.", comment: ""),
                             discussion: "Display the log entries for debugging.")
    )
    var showLogging = false

    @Option(name: .shortAndLong,
            help: ArgumentHelp(NSLocalizedString("default foreground color", comment: ""),
                               discussion: "."))
    var defaultForeground: String?

    mutating func validate() throws {
        guard fetchLimit >= 1 else {
            throw ValidationError("Please specify a 'fetchLimit' of at least 1.")
        }
    }

    func run() async throws {
        guard #available(macOS 12, *) else {
            print("'hncli' isn't supported on this platform.")
            ColorConsole.errorMessage("'hncli' isn't supported on this platform.")
            return
        }

        let api = HackerNewsAPIService()
        api.verbose = verbose
        api.displayJSON = displayJSON

        let dateFormat: DateFormatter = {
            let dateFormat = DateFormatter()
            dateFormat.dateStyle = .medium
            dateFormat.timeStyle = .medium
            dateFormat.timeZone = TimeZone.current
            return dateFormat
        }()

        do {
            if verbose {
                Logger.command.info("Fetchng items limited to \(fetchLimit, privacy: .public)")
                print("🔭 Fetchng items limited to \(fetchLimit)")
            }

            var stories: [Item] = []

            switch searchType {
            case .best:
                stories = try await api.fetchBestStories(fetchLimit)
            case .new:
                stories = try await api.fetchNewStories(fetchLimit)
            case .top:
                stories = try await api.fetchTopStories(fetchLimit)
            }

//            Color256.DEFAULT_FG = .orangeRed1
//            Color256.DEFAULT_BG = .yellow3
//            ColorConsole.consoleMessage("🔭 Fetching \(self.searchType.rawValue) items limited to \(self.fetchLimit)")
//            Color256.DEFAULT_FG = .gold1
//            Color256.DEFAULT_BG = .darkBlue

            // this is simpler :)
            Color256.print("🔭 Fetching \(searchType.rawValue) items limited to \(fetchLimit)",
                           fg: .green1, bg: .darkBlue, att: [.italic])
            print()

            Logger.command.info("search type: \(searchType.rawValue, privacy: .public)")
            Logger.command.info("story count: \(stories.count, privacy: .public)")

            if verbose {
                let msg = "☞ There are \(stories.count) stories"
                ColorConsole.consoleMessage(msg)
            }

            for story in stories {
                if verbose {
                    Logger.command.info("\(story, privacy: .public)\n")
                }

                if displayBrief {
                    if let s = story.title {
                        Color256.print(s, fg: .green1, bg: .darkBlue, att: [.bold, .italic])
                        // ColorConsole.consoleMessage(s)
                    }
                    if let s = story.url {
                        Color256.print(s, fg: .green, bg: .darkBlue, att: [.italic])
                        // ColorConsole.consoleMessage(s)
                    }

                } else {
                    if let s = story.type {
                        ColorConsole.consoleMessage("Item type: \(s)")
                    }

                    if let s = story.time {
                        let t = Date(timeIntervalSince1970: TimeInterval(s))
                        let ts = dateFormat.string(from: t)
                        // Color256.print(ts, fg: .green1, bg: .darkBlue, att: [.italic])
                        ColorConsole.consoleMessage(ts)
                    }

                    if let s = story.title {
                        // Color256.print(s, fg: .green1, bg: .darkBlue, att: [.italic])
                        ColorConsole.consoleMessage(s)
                    }

                    if let s = story.by {
                        // Color256.print(s, fg: .green1, bg: .darkBlue, att: [.italic])
                        ColorConsole.consoleMessage(s)
                    }

                    if let s = story.text {
                        ColorConsole.consoleMessage(s)
                    }

                    if let s = story.url {
                        // Color256.print(s, fg: .green1, bg: .darkBlue, att: [.italic])
                        ColorConsole.consoleMessage(s)
                    }
                }

                print()
            }

        } catch {
            Logger.command.error("\(#function) \(error.localizedDescription, privacy: .public)")
            ColorConsole.errorMessage(error.localizedDescription)
        }

        if showLogging {
            // Logger.exportEntries()

//            print("now general starting yesterday")
//            let date = Calendar.current.date(byAdding: Calendar.Component.day, value: -1, to: Date())
//            var entries = Logger.exportEntries(category: "General", date: date)
//            for entry in entries {
//                print("\(entry)")
//            }
//
//            entries = Logger.exportEntries()
//            print("no args")
//            for entry in entries {
//                print("\(entry)")
//            }

            let entries: [OSLogEntryLog] = Logger.findEntries(subsystem: OSLog.subsystem)
            let estrings =
//                entries.map {
//                    return String(format: "%s",  $0.composedMessage)
//                    return String(format: "[%s] [%s]\t%s", $0.date.formatted(), $0.category, $0.composedMessage)
//                    }
                entries.map {
                    (entry: OSLogEntryLog) -> String in

//                var levelString = ""
//                switch entry.level {
//                case .error:
//                    levelString = "error"
//                case .undefined:
//                    levelString = "undefined"
//                case .debug:
//                    levelString = "debug"
//                case .info:
//                    levelString = "info"
//                case .notice:
//                    levelString = "notice"
//                case .fault:
//                    levelString = "fault"
//                @unknown default:
//                    levelString = "unknown"
//                }

                    // TODO: why is my interp not called?
                    "\(entry)"

                    // return String(format: "%@",  entry.composedMessage)

//                let category = entry.category.padding(toLength: 15, withPad: " ", startingAt: 0)
                    // no return String(format: "[%@] [%10.10@]\t%@", entry.date.formatted(), category, entry.composedMessage)
//                return "[\(entry.date.formatted())] [\(category)] [\(levelString)]\t\(entry.composedMessage)"
                }

//            entries.map { "[\($0.date.formatted())] [\($0.category)] [\($0.level)]\t\t\($0.composedMessage)" }

            for entry in estrings {
                print("\(entry)")
            }
        }
    }
}
