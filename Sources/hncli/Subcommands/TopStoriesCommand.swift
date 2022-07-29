// File:    File.swift
// Project:
// Package:
// Product:
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

import ArgumentParser
import Foundation
import GDTerminalColor
import os.log

extension MainCommandWithSubcommands {
    @available(macOS 10.15, *)
    struct TopStoriesCommand: AsyncParsableCommand {
        static var configuration = CommandConfiguration(
            commandName: "TopStories",
            abstract: "Retrieve the current top stories from Hacker News",
            usage: "xcrun swift run hncli TopStories [--help]",
            discussion: """
            This will retrieve up to 500 IDs of the top stories at Hacker News.
            It's a dumb API, so it will make a request for each ID to get the details.
            This isn't so bad ina GUI where the IDs could be displayed and just the one selected
            fetched. But this is the command line, baby.
            """
        )

        // Options which are defined in MainCommand
        @OptionGroup() var options: Options

        func run() async throws {
            guard #available(macOS 12, *) else {
                print("'hncli' isn't supported on this platform.")
                ColorConsole.errorMessage("'hncli' isn't supported on this platform.")
                return
            }

            let api = HackerNewsAPIService()
            api.verbose = options.verbose
            api.displayJSON = options.displayJSON

            let dateFormat: DateFormatter = {
                let dateFormat = DateFormatter()
                dateFormat.dateStyle = .medium
                dateFormat.timeStyle = .medium
                dateFormat.timeZone = TimeZone.current
                return dateFormat
            }()

            do {
                if options.verbose {
                    Logger.command.info("Fetchng top stories limited to \(options.fetchLimit, privacy: .public)")
                    print("🔭 Fetchng top stories limited to \(options.fetchLimit)")
                }

                // returns an array of Items
                // let stories = try await api.fetchTopStories(options.fetchLimit)
                let stories = try await api.fetchBestStories(options.fetchLimit)

                Logger.command.info("story count: \(stories.count, privacy: .public)")

                if options.verbose {
                    let msg = "☞ There are \(stories.count) stories"
                    ColorConsole.consoleMessage(msg)
                }

                for story in stories {
                    if options.verbose {
                        Logger.command.info("\(story, privacy: .public)\n")
                    }

                    if options.displayBrief {
                        if let s = story.title {
                            // Color256.print(s, fg: .green1, bg: .darkBlue, att: [.italic])
                            ColorConsole.consoleMessage(s)
                        }
                        if let s = story.url {
                            // Color256.print(s, fg: .green1, bg: .darkBlue, att: [.italic])
                            ColorConsole.consoleMessage(s)
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
        }
    }
}
