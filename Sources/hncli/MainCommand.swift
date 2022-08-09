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

//extension MainCommand.ItemDisplayType: ExpressibleByArgument {
//    init?(argument: String) {
//        self.init(rawValue: argument)
//    }
//}

@available(macOS 10.15, *)
@main
struct MainCommand: AsyncParsableCommand {
    static let version = "0.1.10"
    
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
        
        xcrun swift run hncli --brief
        xcrun swift run hncli --fully
        xcrun swift run hncli --prolix
        xcrun swift run hncli --default-item-display-type brief
        
        xcrun swift run hncli --brief --fetch-limit 5 --new
        xcrun swift run hncli --prolix --top

        xcrun swift run hncli --fetch-id 123456 --prolix
        
        xcrun swift run hncli --fetch-limit 5 --new --show-logging --verbose --display-json
        
        xcrun swift run hncli --default-fetch-limit 3
        

        xcrun swift run hncli --color-names
        xcrun swift run hncli --fully -f navyBlue -b dodgerBlue2
        xcrun swift run hncli --default-foreground navyBlue
        xcrun swift run hncli --default-background dodgerBlue2
        xcrun swift run hncli --background grey35 --foreground grey100

        xcrun swift run hncli --background-hex "#696969" --foreground-hex "#DCDCDC"
        
        xcrun swift run hncli Poll
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
    
    struct Options: ParsableArguments {
        
        @Flag(exclusivity: .exclusive,
              help: ArgumentHelp(NSLocalizedString("Choose how the item is displayed.", comment: ""),
                                 discussion: "Choose how the item is displayed"))
        var itemDisplayType: ItemDisplayType =  (Preferences.sharedInstance.itemDisplay ?? .brief)
        
        @Option(name: [.customShort("f"), .long],
                help: ArgumentHelp(NSLocalizedString("foreground color", comment: ""),
                                   discussion: "Set the foreground color"))
        var foreground: String?
        
        @Option(name: [.customShort("b"), .long],
                help: ArgumentHelp(NSLocalizedString("background color", comment: ""),
                                   discussion: "Set the background color"))
        var background: String?
        
        @Option(name: [.long],
                help: ArgumentHelp(NSLocalizedString("foreground color", comment: ""),
                                   discussion: "Set the foreground rgb hex color"))
        var foregroundHex: String?
        
        
        @Option(name: [.long],
                help: ArgumentHelp(NSLocalizedString("background color", comment: ""),
                                   discussion: "Set the background rgb hex color"))
        var backgroundHex: String?
        
        @Option(name: [.long],
                help: ArgumentHelp(NSLocalizedString("foreground color", comment: ""),
                                   discussion: "Set the foreground to a css color name"))
        var foregroundCss: String?
        
        
        @Option(name: [.long],
                help: ArgumentHelp(NSLocalizedString("background color", comment: ""),
                                   discussion: "Set the background to a css color name"))
        var backgroundCss: String?

    }
    @OptionGroup() var commonOptions: Options
    
    
    @Flag(exclusivity: .exclusive,
          help: ArgumentHelp(NSLocalizedString("Choose type of search.", comment: "")))
    var searchType: SearchType = .new
    // This will default to .new. If you want to force the user to specify one of the flags,
    // do not specify a value here.
    
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
    
    @Option(name: .long,
            help: ArgumentHelp(NSLocalizedString("Number of items to fetch.", comment: ""),
                               discussion: "This will fetch only this number of items regardless of the number of IDs"))
    var fetchLimit: Int = Preferences.sharedInstance.fetchLimit
    
    @Option(name: .long,
            help: ArgumentHelp(NSLocalizedString("Fetch specified ID.", comment: ""),
                               discussion: "This will fetch only this ID"))
    var fetchID: Int?
    
    @Option(name: .long,
            help: ArgumentHelp(NSLocalizedString("Fetch user with the specified ID.", comment: ""),
                               discussion: "This will fetch the user with this ID"))
    var fetchUser: String?

    
    
    @Flag(help: ArgumentHelp(NSLocalizedString("Display the log entries for debugging.", comment: ""),
                             discussion: "Display the log entries for debugging.")
    )
    var showLogging = false
    
    
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
            help: ArgumentHelp(NSLocalizedString("default foreground color in hex", comment: ""),
                               discussion: "Set and save the default rgb hex value for the foreground color."))
    var defaultForegroundHex: String?
    
    @Option(name: [.long],
            help: ArgumentHelp(NSLocalizedString("default background color in hex", comment: ""),
                               discussion: "Set and save the default rgb hex value for the background color."))
    var defaultBackgroundHex: String?
    
    @Option(name: [.long],
            help: ArgumentHelp(NSLocalizedString("default fetch limit", comment: ""),
                               discussion: "Set and save the default value for the fetch limit."))
    var defaultFetchLimit: Int?
    
    @Flag(name: [.long],
          help: ArgumentHelp(NSLocalizedString("reset all stored preferences", comment: ""),
                             discussion: "Remove all default values."))
    var resetDefaults = false
    
    
    mutating func validate() throws {
        guard fetchLimit >= 1 else {
            throw ValidationError("Please specify a 'fetchLimit' of at least 1.")
        }
        
        if let fg = commonOptions.foreground {
            if !XTColorName.colorExists(name: fg) {
                throw ValidationError("Invalid color: \(fg) for 'foreground'")
            }
        }
        
        if let bg = commonOptions.background {
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

                    ColorConsole.enablePrintColors()

//                    ColorConsole.enablePrintColors(fg: GDTerminalColorPreferences.sharedInstance.foregroundColorName,
//                                                   bg: GDTerminalColorPreferences.sharedInstance.backgroundColorName)

                    print(s)
                    
                    ColorConsole.disablePrintColors()
                    
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
            ColorConsole.setDefaultForegroundColor(name: value)
        }
        
        if let value = defaultBackground {
            ColorConsole.setDefaultBackgroundColor(name: value)
        }
        
        if let value = defaultForegroundHex {
            ColorConsole.setDefaultForegroundColor(hex: value)
        }
        
        if let value = defaultBackgroundHex {
            ColorConsole.setDefaultBackgroundColor(hex: value)
        }
        
        if let value = defaultFetchLimit {
            Preferences.sharedInstance.fetchLimit = value
        }
        
        if let value = defaultItemDisplayType {
            Preferences.sharedInstance.itemDisplay = value
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
        
        ItemDisplay.setupHexColors(foreground: self.commonOptions.foregroundHex,
                                   background: self.commonOptions.backgroundHex)
        
        ItemDisplay.setupCssColors(foreground: self.commonOptions.foregroundCss,
                                   background: self.commonOptions.backgroundCss)

        ItemDisplay.setupColors(foreground: self.commonOptions.foreground,
                                background: self.commonOptions.background)

        ItemDisplay.useHex = (self.commonOptions.foregroundHex != nil ||
                              self.commonOptions.backgroundHex != nil)

        ItemDisplay.useCss = (self.commonOptions.foregroundCss != nil ||
                              self.commonOptions.backgroundCss != nil)

        
        ItemDisplay.sharedInstance.itemDisplayType = self.commonOptions.itemDisplayType

        if colorNames {
            XTColorName.printColorNames()
            MainCommand.exit(withError: ExitCode.success)
        }
        
        if prolixHelp {
            
            ItemDisplay.sharedInstance.clearScreen()
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
            
            if let id = fetchUser {
                if verbose {
                    Logger.command.info("Fetching user with id \(id, privacy: .public)")
                    print("🔭 Fetching user with id \(id)")
                }

                let user = try await api.fetchUser(id: id)
                ItemDisplay.sharedInstance.display(user: user)
                MainCommand.exit(withError: ExitCode.success)
            }
            
            if let id = fetchID {
                if verbose {
                    Logger.command.info("Fetching item with id \(id, privacy: .public)")
                    print("🔭 Fetching item with id \(id)")
                }

                let item = try await api.fetchItem(id: id)
                ItemDisplay.sharedInstance.display(item: item)
                MainCommand.exit(withError: ExitCode.success)
            }
            
            if verbose {
                Logger.command.info("Fetching items limited to \(self.fetchLimit, privacy: .public)")
                print("🔭 Fetching items limited to \(self.fetchLimit)")
            }
            
            var items: [Item] = []
            
            switch searchType {
            case .best:
                items = try await api.fetchStories(kind: .beststories, fetchLimit: fetchLimit)
            case .new:
                items = try await api.fetchStories(kind: .newstories, fetchLimit: fetchLimit)
            case .top:
                items = try await api.fetchStories(kind: .topstories, fetchLimit: fetchLimit)
            case .ask:
                items = try await api.fetchStories(kind: .askstories, fetchLimit: fetchLimit)
            case .job:
                items = try await api.fetchStories(kind: .jobstories, fetchLimit: fetchLimit)
            case .show:
                items = try await api.fetchStories(kind: .showstories, fetchLimit: fetchLimit)
            }
            

            ItemDisplay.sharedInstance.clearScreen()
            
            let dateFormatter: DateFormatter = {
                let dateFormat = DateFormatter()
                dateFormat.dateStyle = .medium
                dateFormat.timeStyle = .medium
                dateFormat.timeZone = TimeZone.current
                return dateFormat
            }()
            let ts = dateFormatter.string(from: Date())
            //ColorConsole.consoleMessage("Now: \(ts)\n")
            Color256.print("⏰ Now: \(ts)\n",
                           fg: .green1, bg: .darkBlue, att: [.bold, .italic])

            Color256.print("🔭 Fetching \(searchType.rawValue) items limited to \(fetchLimit)",
                           fg: .green1, bg: .darkBlue, att: [.italic])
            print()
            
            
            Logger.command.info("search type: \(searchType.rawValue, privacy: .public)")
            Logger.command.info("story count: \(items.count, privacy: .public)")
            
            if verbose {
                let msg = "☞ There are \(items.count) stories"
                ColorConsole.consoleMessage(msg)
            }
            
            for item in items {
                if verbose {
                    Logger.command.info("\(item, privacy: .public)\n")
                }
                ItemDisplay.sharedInstance.display(item: item)
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
