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



import Foundation
import ArgumentParser
import os.log
import GDTerminalColor


@available(macOS 10.15, *)
@main
struct MainCommand: AsyncParsableCommand {

    static var configuration = CommandConfiguration(
        commandName: "hncli ",
        abstract: "Hacker news frobs",
        usage: "hncli -flags SubCommand -flags",
        version: "0.0.1",
        subcommands: [TopStoriesCommand.self,
                      ProlixHelpCommand.self
                     ],
        defaultSubcommand: ProlixHelpCommand.self
    )

    // Common Options used by other commands
    struct Options: ParsableArguments {

        @Flag(name: .shortAndLong,
              help: ArgumentHelp(NSLocalizedString("Yakity yak.", comment: ""))
        )
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
        
        @Option(name: .shortAndLong, help: "Number of items to fetch")
        var fetchLimit: Int = 500

    }

    @Flag(help: "Display the log entries for debugging.")
    var showLogging = false
    
    @Option(name: .shortAndLong, help: "default foreground color")
    var defaultForeground: String?
    
//    var defaultForeground: String? {
//        didSet {
//            if let am = try? XTermColorDict.colorValue(name: defaultForeground!) {
//               // Color256.DEFAULT_FG = am.rawValue
//                //XTColorName
//            }
//        }
//    }
    
    

//    func run() async throws {
//
//        guard #available(macOS 12, *) else {
//            print("'hncli' isn't supported on this platform.")
//            Self.errorMessage("'hncli' isn't supported on this platform.")
//            return
//        }
//
//        Logger.general.debug("Running")
//        Self.consoleMessage("Howyadoon?")
//
//    }

}
