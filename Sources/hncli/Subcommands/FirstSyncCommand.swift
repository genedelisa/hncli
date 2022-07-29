// File:    Sources
// Project: createMIDI
// Package: createMIDI
// Product: createMIDI
//
// Created by Gene De Lisa on 6/13/22
//
// Using Swift 5.0
// Running macOS 12.4
// Github: https://github.com/genedelisa/createMIDI
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

extension MainCommand {
    struct FirstSyncCommand: ParsableCommand {
        static var configuration = CommandConfiguration(
            commandName: "FirstSync",
            abstract: "This frobs sync"
        )

        func run() throws {
            let s = "\(type(of: self))"
            Logger.service.debug("Yo from \(s)")
        }
    }
}
