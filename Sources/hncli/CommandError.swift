// File:    Sources
// Project: hncli
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



import Foundation
import ArgumentParser
import os.log
import GDTerminalColor

enum CommandError: Error {
    case helpFileNotFound
}

extension CommandError: Equatable {
    public static func == (lhs: CommandError, rhs: CommandError) -> Bool {
        return lhs.localizedDescription == rhs.localizedDescription
    }
}
