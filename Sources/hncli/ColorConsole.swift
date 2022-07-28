// File:    File.swift
// Project:
// Package:
// Product:
//
// Created by Gene De Lisa on 7/27/22
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

import Foundation
import GDTerminalColor
import os.log

struct ColorConsole {
    init() {
        // Color256.DEFAULT_FG = XTColorName.gold1
        Color256.DEFAULT_BG = XTColorName.deepPink4
    }

    static var defaultForeground = "gold1"
    static var defaultBackground = "deepPink4"

    /// Print these ansi codes to the console to turn on these colors.
    /// call `Color256.printReset()` to turn them off.
    /// You can then use ordinary print()
    ///
    /// - Parameters:
    ///   - fg: possible foreground text color. Xwindow color name
    ///   - bg: possible background text color. Xwindow color name
    static func enablePrintColors(fg: String?, bg: String?) {
        var fgCode = Color256.foregroundCode(color: XTColorName.gold1)
        if let fg = fg {
            do {
                fgCode = try Color256.foregroundCode(colorName: fg)
            } catch {
                Logger.ui.warning("bad color name for foreground \(error.localizedDescription)")
                errorMessage("Bad color name: \(fg)")
            }
        }
        // this sets the color. it's the ansi code.
        print("\(fgCode)")

        var bgCode = Color256.backgroundCode(color: XTColorName.navyBlue)
        if let bg = bg {
            do {
                bgCode = try Color256.backgroundCode(colorName: bg)
            } catch {
                Logger.ui.warning("bad color name for background \(error.localizedDescription)")
                errorMessage("Bad color name: \(bg)")
            }
        }
        print("\(bgCode)")
    }

    static func setDefaultForegound(_ colorName: String) {
        if let cv = try? XTermColorDict.colorValue(name: colorName) {
            print("colorName \(colorName) cv \(cv)")
            if let name = XTColorName(rawValue: cv) {
                print("default fg to xtcolorname \(name)")
                Color256.DEFAULT_FG = name
            } else {
                Self.errorMessage("Could not create xtcolorname from rawValue")
            }
        } else {
            Self.errorMessage("\(defaultForeground) is an invalid name")
        }
    }

    static func consoleMessage(_ message: String) {
        Color256.print(message, terminator: "\n")
    }

    static func errorMessage(_ message: String) {
        Color256.print(message,
                       fg: .gold1,
                       bg: .red,
                       att: [.bold])

        Color256.printStderr(message)
    }
}
