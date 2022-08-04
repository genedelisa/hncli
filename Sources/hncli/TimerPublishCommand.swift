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
        
        func makeRequest() async throws {
            // print("\(#function)")
            
            let api = HackerNewsAPIService()
            //api.verbose = true
            //api.displayJSON = true
            let maxID = try await api.fetchMaxID()
            
            let fetchLimit = 3
            let items = try await api.fetchItems(lower: maxID - fetchLimit, upper: maxID)
            
            let dateFormat: DateFormatter = {
                let dateFormat = DateFormatter()
                dateFormat.dateStyle = .medium
                dateFormat.timeStyle = .medium
                dateFormat.timeZone = TimeZone.current
                return dateFormat
            }()
            
            let ts = dateFormat.string(from: Date())
            ColorConsole.consoleMessage("Now: \(ts)")
            print()
            
            
            for story in items {
                if let s = story.time {
                    let t = Date(timeIntervalSince1970: TimeInterval(s))
                    let ts = dateFormat.string(from: t)
                    ColorConsole.consoleMessage("\(ts)")
                }
                if let s = story.id {
                    ColorConsole.consoleMessage("id: \(s)")
                }
                
                if let s = story.type {
                    ColorConsole.consoleMessage(s)
                }
                
                if let s = story.title {
                    ColorConsole.consoleMessage(s)
                }
                
                if let s = story.text {
                    ColorConsole.consoleMessage(s)
                }
                if let s = story.url {
                    ColorConsole.consoleMessage(s)
                }
                print()
            }
            
        }
        
        func run() async throws {
            
            var every = 10.0
            if let i = interval {
                every = i
            }
            
            let subscription = Timer
                .publish(every: every, on: .current, in: .default)
                .autoconnect()
                .sink { date in
                    //let dateFormatter = ISO8601DateFormatter()
                    //print("\(dateFormatter.string(from: date))")
                    
                    Task {
                        do {
                            try await self.makeRequest()
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
