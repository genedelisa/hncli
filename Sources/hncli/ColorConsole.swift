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
    
    static func setupColors(foreground: String?, background: String?) {
        Color256.DEFAULT_FG = XTColorName.gold1
        Color256.DEFAULT_BG = XTColorName.deepPink4

        if let value = ProcessInfo.processInfo.environment["FGCOLOR"]  {
            if let c = XTColorName.from(name: value) {
                Logger.ui.debug("found env fg color for \(value, privacy: .public): \(String(describing:c), privacy: .public)")
                Color256.DEFAULT_FG = c
            }
        }

        if let value = ProcessInfo.processInfo.environment["BGCOLOR"]  {
            if let c = XTColorName.from(name: value) {
                Logger.ui.debug("found env bg color for \(value, privacy: .public): \(String(describing:c), privacy: .public)")
                Color256.DEFAULT_BG = c
            }
        }
        
        if let value = foreground {
            if let c = XTColorName.from(name: value) {
                Logger.ui.debug("found flag fg color for \(value, privacy: .public): \(String(describing:c), privacy: .public)")
                Color256.DEFAULT_FG = c
            }
        }
        
        if let value = background {
            if let c = XTColorName.from(name: value) {
                Logger.ui.debug("found flag bg color for \(value, privacy: .public): \(String(describing:c), privacy: .public)")
                Color256.DEFAULT_BG = c
            }
        }
    }
    

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
                Logger.ui.warning("bad color name for foreground \(error.localizedDescription, privacy: .public)")
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
                Logger.ui.warning("bad color name for background \(error.localizedDescription, privacy: .public)")
                errorMessage("Bad color name: \(bg)")
            }
        }
        print("\(bgCode)")
    }

//    static func setDefaultForegound(_ colorName: String) {
//        if let cv = try? XTermColorDict.colorValue(name: colorName) {
//            print("colorName \(colorName) cv \(cv)")
//            if let name = XTColorName(rawValue: cv) {
//                print("default fg to xtcolorname \(name)")
//                Color256.DEFAULT_FG = name
//            } else {
//                Self.errorMessage("Could not create xtcolorname from rawValue")
//            }
//        } else {
//            Self.errorMessage("\(defaultForeground) is an invalid name")
//        }
//    }

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


// TODO: move this to xtcolorname

extension XTColorName {
    
    static var nameDict = [String: XTColorName]()

    public static func colorExists(name: String) -> Bool {
        
        if nameDict.isEmpty {
            buildNameDict()
        }
        return nameDict[name] != nil
    }
    
    public static func from(name: String) -> XTColorName? {
        
        if nameDict.isEmpty {
            buildNameDict()
        }
        return nameDict[name]
    }
    
    static func buildNameDict() {
        
        for color in Self.allCases {
            nameDict[String(describing: color)] = color
        }
    }
    
    public static func printColorNames() {
        let arr = XTColorName.allCases.map {String(describing:$0)}.sorted()
        for xn in arr {
            print("\(xn)")
        }
    }

    
}
