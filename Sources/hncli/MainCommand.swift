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

extension MainCommand.ItemDisplayType: ExpressibleByArgument {
    init?(argument: String) {
        self.init(rawValue: argument)
    }
}

@available(macOS 10.15, *)
@main
struct MainCommand: AsyncParsableCommand {
    static let version = "0.1.0"
    
    static var configuration = CommandConfiguration(
        commandName: "hncli ",
        abstract: "Hacker news frobs",
        usage: """
        xcrun swift run hncli -h
        xcrun swift run hncli --prolix-help
        
        xcrun swift run hncli --best
        xcrun swift run hncli --new
        xcrun swift run hncli --top
        xcrun swift run hncli --ask
        xcrun swift run hncli --job
        xcrun swift run hncli --show
        (unspecified defaults to --new)
        
        xcrun swift run hncli --enable-display-brief --fetch-limit 5 --new
        xcrun swift run hncli --disable-display-brief --top
        
        xcrun swift run hncli --fetch-limit 5 --new --show-logging --verbose --display-json
        
        xcrun swift run hncli --default-fetch-limit 3
        xcrun swift run hncli --default-display-brief false
        
        xcrun swift run hncli --color-names
        xcrun swift run hncli --disable-display-brief -f navyBlue -b dodgerBlue2
        xcrun swift run hncli --default-foreground navyBlue
        xcrun swift run hncli --default-background dodgerBlue2
        xcrun swift run hncli --background grey35 --foreground grey100
        
        """,
        version: version,
        subcommands: [TimerPublishCommand.self]
        
    )
    
    enum SearchType: String, EnumerableFlag, Codable {
        case best
        case new
        case top
        case ask
        case job
        case show
    }

    enum ItemDisplayType: String, EnumerableFlag, Codable {
        case brief
        case fully
        case prolix
    }
    

    
    @Flag(exclusivity: .exclusive,
          help: ArgumentHelp(NSLocalizedString("Choose type of search.", comment: "")))
    var searchType: SearchType = .new
    // This will default to .new. If you want to force the user to specify one of the flags,
    // do not specify a value here.
    
    @Flag(exclusivity: .exclusive,
          help: ArgumentHelp(NSLocalizedString("Choose how the item is displayed.", comment: ""),
                             discussion: "Choose how the item is displayed"))
    var itemDisplayType: ItemDisplayType =  (Preferences.sharedInstance.itemDisplay ?? .brief)
    
    @Option(
            help: ArgumentHelp(NSLocalizedString("default display of items", comment: ""),
                               discussion: "Set and save the default value for the display type."))
    var defaultItemDisplayType: ItemDisplayType?

    
    @Flag(name: .shortAndLong,
          help: ArgumentHelp(NSLocalizedString("Yakity yak.", comment: "")))
    var verbose = false
    
    @Flag(
        help: ArgumentHelp(NSLocalizedString("Display the current version.", comment: ""),
                           discussion: "This will display the current version then exit")
    )
    var version = false
    
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
    
//    @Flag(inversion: .prefixedEnableDisable,
//          help: ArgumentHelp(NSLocalizedString("Display the items briefly .", comment: ""),
//                             discussion: "This will print just the title and url of the item")
//    )
//    var displayBrief = Preferences.sharedInstance.brief
    
    @Option(name: .long,
            help: ArgumentHelp(NSLocalizedString("Number of items to fetch.", comment: ""),
                               discussion: "This will fetch only this number of items regardless of the number of IDs"))
    var fetchLimit: Int = Preferences.sharedInstance.fetchLimit
    
    @Option(name: .long,
            help: ArgumentHelp(NSLocalizedString("Fetch specified ID.", comment: ""),
                               discussion: "This will fetch only this ID"))
    var fetchID: Int?
    
    
    @Flag(help: ArgumentHelp(NSLocalizedString("Display the log entries for debugging.", comment: ""),
                             discussion: "Display the log entries for debugging.")
    )
    var showLogging = false
    
    @Option(name: [.customShort("f"), .long],
            help: ArgumentHelp(NSLocalizedString("foreground color", comment: ""),
                               discussion: "Set the foreground color"))
    var foreground: String?
    
    
    @Option(name: [.customShort("b"), .long],
            help: ArgumentHelp(NSLocalizedString("background color", comment: ""),
                               discussion: "Set the background color"))
    var background: String?
    
    @Flag(name: [.long],
          help: ArgumentHelp(NSLocalizedString("print valid color names", comment: ""),
                             discussion: "Display all valid color names then exit."))
    var colorNames = false
    
    // options for defaults
    
    @Option(name: [.long],
            help: ArgumentHelp(NSLocalizedString("default foreground color", comment: ""),
                               discussion: "Set and save the default value for the foreground color."))
    var defaultForeground: String?
    
    @Option(name: [.long],
            help: ArgumentHelp(NSLocalizedString("default background color", comment: ""),
                               discussion: "Set and save the default value for the background color."))
    var defaultBackground: String?
    
    @Option(name: [.long],
            help: ArgumentHelp(NSLocalizedString("default fetch limit", comment: ""),
                               discussion: "Set and save the default value for the fetch limit."))
    var defaultFetchLimit: Int?
    
//    @Option(name: [.long],
//            help: ArgumentHelp(NSLocalizedString("default display is brief", comment: ""),
//                               discussion: "Set and save the default value for the display type. Brief is just the title and url."))
//    var defaultDisplayBrief: Bool?
    
    
    @Flag(name: [.long],
          help: ArgumentHelp(NSLocalizedString("reset all stored preferences", comment: ""),
                             discussion: "Remove all default values."))
    var resetDefaults = false
    
    
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
        
        if let value = defaultForeground {
            if !XTColorName.colorExists(name: value) {
                throw ValidationError("Invalid color: \(value) for 'defaultForeground'")
            }
        }
        
        if let value = defaultBackground {
            if !XTColorName.colorExists(name: value) {
                throw ValidationError("Invalid color: \(value) for 'defaultBackground'")
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
    
    func errorMessage(_ message: String) {
        Color256.print(message,
                       fg: .gold1,
                       bg: .red,
                       att: [.bold])
    }
    
    func message(_ message: String) {
        Color256.print(message, terminator: "\n")
    }
    
    func checkAndSetDefaults() {
        
        if resetDefaults {
            Preferences.resetDefaults()
            Preferences.sharedInstance.resetAll()
            GDTerminalColorPreferences.resetDefaults()
            GDTerminalColorPreferences.sharedInstance.resetAll()
            
            MainCommand.exit(withError: ExitCode.success)
        }
        
        // if the flag is set on the command line, save it in preferences
        
        if let value = defaultForeground {
            //Preferences.sharedInstance.foregroundColorName = value
            GDTerminalColorPreferences.sharedInstance.foregroundColorName = value
            
        }
        
        if let value = defaultBackground {
            //Preferences.sharedInstance.backgroundColorName = value
            GDTerminalColorPreferences.sharedInstance.backgroundColorName = value
        }
        
        if let value = defaultFetchLimit {
            Preferences.sharedInstance.fetchLimit = value
        }
        
//        if let value = defaultDisplayBrief {
//            Preferences.sharedInstance.brief = value
//        }
        
        if let value = defaultItemDisplayType {
            Preferences.sharedInstance.itemDisplay = value
        }

    }

    func display(item: Item) {
        switch(itemDisplayType) {
        case .brief:
            displayItemBriefly(item: item)
        case .fully:
            displayItemFully(item: item)
        case .prolix:
            displayItemProlix(item: item)
        }
    }
    
    func displayItemBriefly(item: Item) {
        if item.type == "comment" {
            if let s = item.id {
                ColorConsole.consoleMessage("ID: \(s)")
            }
            if let s = item.parent {
                ColorConsole.consoleMessage("Parent: \(s)")
            }
            if let s = item.by {
                ColorConsole.consoleMessage("By: \(s)")
            }
            if let s = item.text {
                ColorConsole.consoleMessage("Text: \(s)")
            }
            return
        }
        
        if let s = item.title {
            //Color256.print(s, fg: .green1, bg: .darkBlue, att: [.bold, .italic])
            ColorConsole.consoleMessage("\(s)")
        }
        if let s = item.url {
            //Color256.print(s, fg: .green, bg: .darkBlue, att: [.italic])
            ColorConsole.consoleMessage("\(s)")
        }
    }
    
    func displayItemFully(item: Item) {
        let dateFormat: DateFormatter = {
            let dateFormat = DateFormatter()
            dateFormat.dateStyle = .medium
            dateFormat.timeStyle = .medium
            dateFormat.timeZone = TimeZone.current
            return dateFormat
        }()
        
        if let s = item.time {
            let t = Date(timeIntervalSince1970: TimeInterval(s))
            let ts = dateFormat.string(from: t)
            // Color256.print(ts, fg: .green1, bg: .darkBlue, att: [.italic])
            ColorConsole.consoleMessage(ts)
        }
        
        if let s = item.id {
            ColorConsole.consoleMessage("ID: \(s)")
        }
        
        if let s = item.type {
            ColorConsole.consoleMessage("Type: \(s)")
        }
        
        if let s = item.title {
            // Color256.print(s, fg: .green1, bg: .darkBlue, att: [.italic])
            ColorConsole.consoleMessage(s)
        }
        
        if let s = item.by {
            // Color256.print(s, fg: .green1, bg: .darkBlue, att: [.italic])
            ColorConsole.consoleMessage(s)
        }
        
        if let s = item.text {
            ColorConsole.consoleMessage(s)
        }
        
        if let s = item.url {
            // Color256.print(s, fg: .green1, bg: .darkBlue, att: [.italic])
            ColorConsole.consoleMessage(s)
        }
    }
    
    func displayItemProlix(item: Item) {
        let dateFormat: DateFormatter = {
            let dateFormat = DateFormatter()
            dateFormat.dateStyle = .medium
            dateFormat.timeStyle = .medium
            dateFormat.timeZone = TimeZone.current
            return dateFormat
        }()
        
        if let s = item.time {
            let t = Date(timeIntervalSince1970: TimeInterval(s))
            let ts = dateFormat.string(from: t)
            // Color256.print(ts, fg: .green1, bg: .darkBlue, att: [.italic])
            ColorConsole.consoleMessage(ts)
        }
        
        if let s = item.id {
            ColorConsole.consoleMessage("ID: \(s)")
        }
        if let s = item.parent {
            ColorConsole.consoleMessage("Parent: \(s)")
        }
        
        if let s = item.type {
            ColorConsole.consoleMessage("Type: \(s)")
        }
        
        if let s = item.title {
            // Color256.print(s, fg: .green1, bg: .darkBlue, att: [.italic])
            ColorConsole.consoleMessage("title: \(s)")
        }
        
        if let s = item.by {
            ColorConsole.consoleMessage("by: \(s)")
        }

        if let s = item.descendants {
            ColorConsole.consoleMessage("descendants: \(s)")
        }
        
        if let s = item.kids {
            ColorConsole.consoleMessage("kids: \(s)")
        }
        
        if let s = item.score {
            ColorConsole.consoleMessage("score: \(s)")
        }

        if let s = item.deleted {
            ColorConsole.consoleMessage("deleted: \(s)")
        }

        if let s = item.dead {
            ColorConsole.consoleMessage("dead: \(s)")
        }
        
        if let s = item.poll {
            ColorConsole.consoleMessage("poll: \(s)")
        }
        if let s = item.parts {
            ColorConsole.consoleMessage("parts: \(s)")
        }
        
        if let s = item.text {
            ColorConsole.consoleMessage("Text: \(s)")
        }
        
        if let s = item.url {
            ColorConsole.consoleMessage(s)
        }
    }
    
    func run() async throws {
        
        guard #available(macOS 12, *) else {
            print("'hncli' isn't supported on this platform.")
            ColorConsole.errorMessage("'hncli' isn't supported on this platform.")
            return
        }
        
        if Preferences.sharedInstance.isFirstRun() {
            Logger.command.debug("first run")
        }
        
        if version {
            print("version: \(Self.version)")
            MainCommand.exit(withError: ExitCode.success)
        }
        checkAndSetDefaults()
        
        ColorConsole.setupColors(foreground: foreground, background: background)
        
        if colorNames {
            XTColorName.printColorNames()
            MainCommand.exit(withError: ExitCode.success)
        }
        
        if prolixHelp {
            
            Preferences.sharedInstance.printAllInSuite()
            
            showHelp()
            
            MainCommand.exit(withError: ExitCode.success)
            
            //throw CleanExit.message("End of help message")
            //throw CleanExit.helpRequest(ProlixHelpCommand)
        }
        
        let api = HackerNewsAPIService()
        api.verbose = verbose
        api.displayJSON = displayJSON
        
        do {
            if let id = fetchID {
                if verbose {
                    Logger.command.info("Fetching item with id \(id, privacy: .public)")
                    print("🔭 Fetching item with id \(id)")
                }

                let item = try await api.fetchItem(id: id)
                display(item: item)
                MainCommand.exit(withError: ExitCode.success)
            }
            
            if verbose {
                Logger.command.info("Fetching items limited to \(self.fetchLimit, privacy: .public)")
                print("🔭 Fetching items limited to \(self.fetchLimit)")
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
                display(item: story)
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
