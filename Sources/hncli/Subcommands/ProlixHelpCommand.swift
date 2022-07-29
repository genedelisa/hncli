// File:    Sources
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

import ArgumentParser
import Foundation
import GDTerminalColor
import os.log

extension MainCommandWithSubcommands {
    @available(macOS 10.15, *)
    struct ProlixHelpCommand: AsyncParsableCommand {
        static var configuration = CommandConfiguration(
            commandName: "prolixHelp",
            abstract: "This displays the help file"
        )

        @OptionGroup() var options: Options

        @Option(help: "foreground color")
        var fg: String?

        @Option(help: "background color")
        var bg: String?

        var defaultHelpFG = XTColorName.gold1.rawValue

        var defaultHelpBG = XTColorName.darkBlue.rawValue

        @Option(name: .shortAndLong, help: "default foreground color")
        var defaultForeground: String?

        func showHelp() throws {
//            print("fg \(fg)")
//            print("bg \(bg)")
//            print("defaultForeground \(defaultForeground)")
//
//
//            if let dfg = defaultForeground {
//                ColorConsole.setDefaultForegound(dfg)
//                print("setting default fg \(dfg)")
//                if options.verbose {
//
//                }
//            } else {
//                print("dfg is not set")
//            }

            if let helpURL = Bundle.module.url(forResource: "help",
                                               withExtension: "txt") {
                do {
                    let data = try Data(contentsOf: helpURL)
                    if let s = String(data: data, encoding: .utf8) {
                        print(s)
//                        ColorConsole.consoleMessage(s)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            } else {
                throw CommandError.helpFileNotFound
                //                    errorMessage("The help file was not found.")
            }
        }

        func errorMessage(_ message: String) {
            Color256.print(message,
                           fg: .gold1,
                           bg: .red,
                           att: [.bold])
        }

        func run() async throws {
            let s = "\(type(of: self))"
            Logger.general.debug("Yo from \(s)")

            // not called
//            defer {
//                Color256.printReset()
//                print("reset")
//            }

            if options.verbose {}

            ColorConsole.enablePrintColors(fg: fg, bg: bg)

//            var fgCode = Color256.foregroundCode(color: defaultHelpFG)
//            if let foreground = fg {
//                do {
//                    fgCode = try Color256.foregroundCode(colorName: foreground)
//                } catch {
//                    Logger.ui.warning("bad color name for foreground \(error.localizedDescription)")
//                    errorMessage("Bad color name: \(foreground)")
//                }
//            }
//
//            // this sets the color. it's the ansi code.
//            print("\(fgCode)")
//
//            var bgCode = Color256.backgroundCode(color: defaultHelpBG)
//            if let background = bg {
//                do {
//                    bgCode = try Color256.backgroundCode(colorName: background)
//                } catch {
//                    Logger.ui.warning("bad color name for background \(error.localizedDescription)")
//                    errorMessage("Bad color name: \(background)")
//                }
//            }
//            print("\(bgCode)")

            do {
                try showHelp()
            } catch {
                Color256.printReset()
                Self.exit(withError: CommandError.helpFileNotFound)
            }

            Color256.printReset()
            Self.exit()
        }
    }
}
