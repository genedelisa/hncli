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
        case ask
        case job
        case show
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

    @Option(name: .long,
            help: ArgumentHelp(NSLocalizedString("Number of items to fetch.", comment: ""),
                               discussion: "This will fetch only this number of items regardless of the number of IDs"))
    var fetchLimit: Int = 500

    @Flag(help: ArgumentHelp(NSLocalizedString("Display the log entries for debugging.", comment: ""),
                             discussion: "Display the log entries for debugging.")
    )
    var showLogging = false

    @Option(name: [.customShort("f"), .long],
            help: ArgumentHelp(NSLocalizedString("default foreground color", comment: ""),
                               discussion: "."))
    var foreground: String?
    

    @Option(name: [.customShort("b"), .long],
            help: ArgumentHelp(NSLocalizedString("default background color", comment: ""),
                               discussion: "."))
    var background: String?
    
    @Flag(name: [.long],
            help: ArgumentHelp(NSLocalizedString("print valid color names", comment: ""),
                               discussion: "."))
    var colorNames = false
    
    

    mutating func validate() throws {
        guard fetchLimit >= 1 else {
            throw ValidationError("Please specify a 'fetchLimit' of at least 1.")
        }
        if let fg = foreground {
            if !XTColorName.colorExists(name: fg) {
                throw ValidationError("Invalid color: \(fg) for 'foreground'")
            }
        }
        if let bg = background {
            if !XTColorName.colorExists(name: bg) {
                throw ValidationError("Invalid color: \(bg) for 'background'")
            }
        }
    }
    
    
    func showHelp() {
        if let helpURL = Bundle.module.url(forResource: "help",
                                           withExtension: "txt") {
            do {
                let data = try Data(contentsOf: helpURL)
                if let s = String(data: data, encoding: .utf8) {
                    print(s)
                }
            } catch {
                print(error.localizedDescription)
            }
        } else {
            errorMessage("The help file was not found.")
        }
    }
    
//    func printColorNames() {
//        let arr = XTColorName.allCases.map {String(describing:$0)}.sorted()
//        for xn in arr {
//            print("\(xn)")
//        }
//    }
    
    func errorMessage(_ message: String) {
        Color256.print(message,
                       fg: .gold1,
                       bg: .red,
                       att: [.bold])
    }
    
    func message(_ message: String) {
        Color256.print(message, terminator: "\n")
    }


    func run() async throws {
        guard #available(macOS 12, *) else {
            print("'hncli' isn't supported on this platform.")
            ColorConsole.errorMessage("'hncli' isn't supported on this platform.")
            return
        }
        
        ColorConsole.setupColors(foreground: foreground, background: background)
        
        if colorNames {
            XTColorName.printColorNames()
            MainCommand.exit(withError: ExitCode.success)
        }
        
//        if let fg = foreground {
//            if let c = XTColorName.from(name: fg) {
//                print("found color for \(fg): \(c)")
//                Color256.DEFAULT_FG = c
//            }
//        }
//        
//        if let bg = background {
//            if let c = XTColorName.from(name: bg) {
//                print("found color for \(bg): \(c)")
//                Color256.DEFAULT_BG = c
//            }
//        }
        
//        for xn in XTColorName.allCases {
//            if xn.rawValue == 2 {
//                print("found color 2: \(xn)")
//                let name = String(describing: xn)
//                print(name)
//                break
//            }
//            print("checking color: \(xn)")
//
//        }

//        if Preferences.sharedInstance.verbose {
//            print("preferences verbose from cmd: \(verbose)")
//        }
        
        if prolixHelp {
            
            showHelp()
             MainCommand.exit(withError: ExitCode.success)
            
            //throw CleanExit.message("End of help message")
            //throw CleanExit.helpRequest(ProlixHelpCommand)
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
                Logger.command.info("Fetchng items limited to \(self.fetchLimit, privacy: .public)")
                print("🔭 Fetchng items limited to \(self.fetchLimit)")
            }

            var stories: [Item] = []

            switch searchType {
            case .best:
                stories = try await api.fetchStories(kind: .beststories, fetchLimit: fetchLimit)
            case .new:
                stories = try await api.fetchStories(kind: .newstories, fetchLimit: fetchLimit)
            case .top:
                stories = try await api.fetchStories(kind: .topstories, fetchLimit: fetchLimit)
            case .ask:
                stories = try await api.fetchStories(kind: .askstories, fetchLimit: fetchLimit)
            case .job:
                stories = try await api.fetchStories(kind: .jobstories, fetchLimit: fetchLimit)
            case .show:
                stories = try await api.fetchStories(kind: .showstories, fetchLimit: fetchLimit)
            }


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
            
            let entries: [OSLogEntryLog] = Logger.findEntries(subsystem: OSLog.subsystem)
            let estrings =
            entries.map {
                (entry: OSLogEntryLog) -> String in
                "\(entry)"
            }
            
            for entry in estrings {
                print("\(entry)")
            }
        }
    }
}
