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
    @available(macOS 10.15, *)
    struct FirstCommand: AsyncParsableCommand {
        static var configuration = CommandConfiguration(
            commandName: "First",
            abstract: "This frobs first"
        )

        @OptionGroup() var options: Options

        // @Argument(help: ArgumentHelp(NSLocalizedString("Your account ID.", comment: "")))
        // var accountID: String

        @Option(name: .shortAndLong, help: "Path to the thing")
        var thing: String?

        func run() async throws {
            let s = "\(type(of: self))"
            Logger.general.debug("Yo from \(s)")
        }
    }
}
