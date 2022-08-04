// File:    TimerCommand.swift
// Project: clPoll
// Package: clPoll
// Product: clPoll
//
// Created by Gene De Lisa on 8/4/22
//
// Using Swift 5.0
// Running macOS 12.5
// Github: https://github.com/genedelisa/clPoll
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
import os.log
import OSLog
import Combine
import GDTerminalColor


extension MainCommand {
    
    struct TimerPublishCommand: AsyncParsableCommand {
        
        static var configuration = CommandConfiguration(
            commandName: "Poll"
        )
        @OptionGroup() var commonOptions: Options

        @Option(name: [.customShort("i"), .long],
                help: ArgumentHelp(NSLocalizedString("Interval", comment: ""),
                                   discussion: "Set the publish interval"))
        var interval: Double?


        func validate() throws {
            if let i = interval {
                if i <= 0.0 {
                    throw ValidationError("Please specify a 'interval' > 0.")
                }
            }
        }
        
        func makeRequest() async throws -> [Item] {
            // print("\(#function)")
            
            let api = HackerNewsAPIService()
            //api.verbose = true
            //api.displayJSON = true
            let maxID = try await api.fetchMaxID()
            
            let fetchLimit = 3
            let items = try await api.fetchItems(lower: maxID - fetchLimit, upper: maxID)
            return items
            
        }
        
        func run() async throws {
            
            var every = 10.0
            if let i = interval {
                every = i
            }
            
            ItemDisplay.setupColors(foreground: self.commonOptions.foreground, background: self.commonOptions.background)
//            ColorConsole.setupColors(foreground: commonOptions.foreground, background: commonOptions.background)
            
            ItemDisplay.sharedInstance.itemDisplayType = self.commonOptions.itemDisplayType

            
            let subscription = Timer
                .publish(every: every, on: .current, in: .default)
                .autoconnect()
                .sink { date in
                    
                    //let dateFormatter = ISO8601DateFormatter()
                    let dateFormatter: DateFormatter = {
                        let dateFormat = DateFormatter()
                        dateFormat.dateStyle = .medium
                        dateFormat.timeStyle = .medium
                        dateFormat.timeZone = TimeZone.current
                        return dateFormat
                    }()
                    let ts = dateFormatter.string(from: date)
                    ItemDisplay.sharedInstance.clearScreen()
                    ColorConsole.consoleMessage("Now: \(ts)\n")
                    
                    Task {
                        do {
                            let items = try await self.makeRequest()
                            for item in items {
                                ItemDisplay.sharedInstance.display(item: item)
                                print()
                            }
                            
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
            
            withExtendedLifetime(subscription) {
                RunLoop.current.run()
            }
        }
    }
}
