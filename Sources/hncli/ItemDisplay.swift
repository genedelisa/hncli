// File:    File.swift
// Project: 
// Package: 
// Product: 
//
// Created by Gene De Lisa on 8/4/22
//
// Using Swift 5.0
// Running macOS 12.5
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
import OSLog

enum ItemDisplayType: String, EnumerableFlag, Codable {
    case brief
    case fully
    case prolix
}

extension ItemDisplayType: ExpressibleByArgument {
    init?(argument: String) {
        self.init(rawValue: argument)
        print("init by arg \(argument)")
    }
}


struct ItemDisplay {
    
    static var sharedInstance = ItemDisplay()
    
    var itemDisplayType: ItemDisplayType =  (Preferences.sharedInstance.itemDisplay ?? .brief)

    let dateFormat: DateFormatter = {
        let dateFormat = DateFormatter()
        dateFormat.dateStyle = .medium
        dateFormat.timeStyle = .medium
        dateFormat.timeZone = TimeZone.current
        return dateFormat
    }()
    
    static var useHex = false
    static var useCss = false
    
    
    static var foreground: String?
    static var background: String?
    static var foregroundHex: String?
    static var backgroundHex: String?
    static var foregroundCss: String?
    static var backgroundCss: String?

    
    static func setupColors(foreground: String? = nil, background: String? = nil) {
        ColorConsole.setupColors(foreground: foreground, background: background)
    }

    static func setupHexColors(foreground: String? = nil, background: String? = nil) {
        ColorConsole.setupHexColors(foreground: foreground, background: background)
    }
    static func setupCssColors(foreground: String? = nil, background: String? = nil) {
        ColorConsole.setupCssColors(foreground: foreground, background: background)
    }

    func clearScreen() {
        Color256.clearScreen()
    }
    
    // TODO: these are awful clean them up
    
    func message(_ s: String,
                 fg: XTColorName? = nil,
                 bg: XTColorName? = nil,
                 att: Attributes? = nil,
                 bgatt: Attributes? = nil,
                 fgHex: String? = nil,
                 bgHex: String? = nil,
                 terminator: String = "\n") {


        //print("\(#function)")
        
        if Self.useHex {

//            print("printing hex Color24.DEFAULT_FG \(Color24.DEFAULT_FG)")
//            print("printing hex fgHex \(String(describing: fgHex))")
//            print("printing Self.foregroundHex \(String(describing: Self.foregroundHex))")
//            print("printing Self.backgroundHex \(String(describing: Self.backgroundHex))")
            //ColorConsole.consoleMessage("np \(s)")


//            ColorConsole.consoleMessageHex("\(s)",
//                                           fgHex: fgHex == nil ? Color24.DEFAULT_FG : fgHex!,
//                                           bgHex: bgHex == nil ? Color24.DEFAULT_BG : bgHex!,
//                                           terminator: terminator)
            
//            ColorConsole.consoleMessageHex("\(s)",
//                                           fgHex: fgHex,
//                                           bgHex: bgHex,
//                                           terminator: terminator)
            
//            ColorConsole.consoleMessageHex("\(s)",
//                                           fgHex: Self.foregroundHex,
//                                           bgHex: Self.backgroundHex,
//                                           terminator: terminator)
            
            Color24.printHex("\(s)",
                          fgHex: Self.foregroundHex,
                          bgHex: Self.backgroundHex,
                          terminator: terminator)
            
        } else if Self.useCss {

                Color24.print(s,
                              fgColorName: Self.foregroundCss,
                              bgColorName: Self.backgroundCss)
                                           
        } else {
           // print("printing neither hex nor css")
            ColorConsole.consoleMessage("\(s)",
                                        fg: fg == nil ? Color256.DEFAULT_FG : fg!,
                                        bg: bg == nil ? Color256.DEFAULT_BG : bg!,
                                        att: att,
                                        bgatt: bgatt,
                                        terminator: terminator)
        }
    }
    
//    id    The user's unique username. Case-sensitive. Required.
//    created    Creation date of the user, in Unix Time.
//    karma    The user's karma.
//    about    The user's optional self-description. HTML.
//    submitted    List of the user's stories, polls and comments.

    func display(user: User) {
        if let s = user.id {
            ColorConsole.consoleMessage("ID: \(s)")
        }
        if let s = user.about {
            ColorConsole.consoleMessage("About: \(s)")
        }
        if let s = user.created {
            let t = Date(timeIntervalSince1970: TimeInterval(s))
            let ts = dateFormat.string(from: t)
            ColorConsole.consoleMessage("Created: \(ts)")
//            ColorConsole.consoleMessage(ts, fg: .green1, bg: .darkBlue, att: [.italic])
        }
        if let s = user.karma {
            ColorConsole.consoleMessage("Karma: \(s)")
        }
        if let s = user.submitted {
            ColorConsole.consoleMessage("Submitted: \(s)")
        }

    }
    
    func display(item: Item) {

        switch(itemDisplayType) {
        case .brief:
            displayItemBriefly(item: item)
        case .fully:
            displayItemFully(item: item)
        case .prolix:
            displayItemProlix(item: item)
        }
    }
    
    func displayItemTime(item: Item) {
        
        if let s = item.time {
            let t = Date(timeIntervalSince1970: TimeInterval(s))
            let ts = dateFormat.string(from: t)
            ColorConsole.consoleMessage(ts,
                                        fg: .green1,
                                        bg: .darkBlue,
                                        att: [.italic])
        }
    }
    
    func displayItemBriefly(item: Item) {

        // inconsistent. An ask type seems to come over as a story type.
        
        switch item.type {
            
        case "comment":

            displayItemTime(item: item)
            
            if let s = item.id {
                message("ID: \(s)")
            }
            if let s = item.parent {
                message("Parent: \(s)")
            }
            if let s = item.by {
                message("By: \(s)")
            }
            if let s = item.text {
                message("Text: \(s)")
            }
            return
            
        case "story":

            displayItemTime(item: item)
            
            if let s = item.title {
                message("\(s)")
                
//                ColorConsole.consoleMessage("\(s)")
//                ColorConsole.consoleMessage("\(s)",
//                                            fg: .green1, bg: .darkBlue, att: [.bold, .italic])
            }
            if let s = item.url {
                message("\(s)")
            }
           
            return
            
        case "job":
            
            displayItemTime(item: item)

            if let s = item.title {
                message("\(s)")
            }

            if let s = item.url {
                message("\(s)")
            }


//            if let s = item.id {
//                ColorConsole.consoleMessage("ID: \(s)")
//            }
//            if let s = item.title {
//                ColorConsole.consoleMessage("title: \(s)")
//            }
//            if let s = item.by {
//                ColorConsole.consoleMessage("by: \(s)")
//            }
//            if let s = item.url {
//                ColorConsole.consoleMessage("url: \(s)")
//            }
//            if let s = item.score {
//                ColorConsole.consoleMessage("score: \(s)")
//            }
            return
            
        case "poll":

            if let s = item.id {
                message("ID: \(s)")
            }
            if let s = item.parent {
                message("Parent: \(s)")
            }
            if let s = item.by {
                message("By: \(s)")
            }
            if let s = item.text {
                message("Text: \(s)")
            }
            return
            
        case "ask":
            
            // never gets here
            
            print("ask")
            if let s = item.id {
                ColorConsole.consoleMessage("ID: \(s)")
            }
            if let s = item.parent {
                ColorConsole.consoleMessage("Parent: \(s)")
            }
            if let s = item.by {
                ColorConsole.consoleMessage("By: \(s)")
            }
            if let s = item.text {
                ColorConsole.consoleMessage("Text: \(s)")
            }
            return
            
        case "user":
            print("user")
            
        default:
            print("huh? \(item.type!)")
        }
        
       
    }

   
    
    func displayItemFully(item: Item) {
        
        displayItemTime(item: item)
        
        
        if let s = item.id {
            message("ID: \(s)")
        }
        
        if let s = item.type {
            message("Type: \(s)")
        }
        
        if let s = item.title {
            // Color256.print(s, fg: .green1, bg: .darkBlue, att: [.italic])
            message(s)
        }
        
        if let s = item.by {
            // Color256.print(s, fg: .green1, bg: .darkBlue, att: [.italic])
            message(s)
        }
        
        if let s = item.text {
            message(s)
        }
        
        if let s = item.url {
            // Color256.print(s, fg: .green1, bg: .darkBlue, att: [.italic])
            message(s)
        }
    }
    
    func displayItemProlix(item: Item) {
        
        displayItemTime(item: item)
        
        if let s = item.id {
            message("ID: \(s)")
        }
        if let s = item.parent {
            message("Parent: \(s)")
        }
        
        if let s = item.type {
            message("Type: \(s)")
        }
        
        if let s = item.title {
            // Color256.print(s, fg: .green1, bg: .darkBlue, att: [.italic])
            message("title: \(s)")
        }
        
        if let s = item.by {
            message("by: \(s)")
        }

        if let s = item.descendants {
            message("descendants: \(s)")
        }
        
        if let s = item.kids {
            message("kids: \(s)")
        }
        
        if let s = item.score {
            message("score: \(s)")
        }

        if let s = item.deleted {
            message("deleted: \(s)")
        }

        if let s = item.dead {
            message("dead: \(s)")
        }
        
        if let s = item.poll {
            message("poll: \(s)")
        }
        if let s = item.parts {
            message("parts: \(s)")
        }
        
        if let s = item.text {
            message("Text: \(s)")
        }
        
        if let s = item.url {
            message(s)
        }
    }

    
}


// MARK: Color Palette
extension ItemDisplay {
    
//    lazy var colorPalette: ColorPalette = {
//        return Self.decodeColorPalette()
//    }()
    
    static func decodeColorPalette() -> ColorPalette {
        let basename = "colorPalette"
        let decoder = JSONDecoder()
        let path = Bundle.module.path(forResource: basename, ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: path))
        let decoded = try! decoder.decode(ColorPalette.self, from: data)
        return decoded
    }
    
//    func testpal() {
//        let c = colorPalette.colors[0]
//        Color24.DEFAULT_FG = "#\(c.hex)"
//        
//        print(Color24.fgString("Astronomical Twilight Begin", paletteColor: c))
//
//        Logger.ui.debug("showing colors \(c.name, privacy: .public)")
//        
//        print(Color24.fgString("\(colorPalette.colors[0].name)", paletteColor: colorPalette.colors[0]))
//        print(Color24.fgString("\(colorPalette.colors[1].name)", paletteColor: colorPalette.colors[1]))
//        print(Color24.fgString("\(colorPalette.colors[2].name)", paletteColor: colorPalette.colors[2]))
//        print(Color24.fgString("\(colorPalette.colors[3].name)", paletteColor: colorPalette.colors[3]))
//        print(Color24.fgString("\(colorPalette.colors[4].name)", paletteColor: colorPalette.colors[4]))
//    }
    
}

extension ColorConsole {
    public static func consoleMessage(_ message: String,
                                      fgHex: String = Color24.DEFAULT_FG,
                                      bgHex: String = Color24.DEFAULT_BG,
                                      terminator: String = "\n") {
        
        print("hey default fg \(Color24.DEFAULT_FG)")
        Color24.printHex(message,
                      fgHex: fgHex,
                      bgHex: bgHex,
                      terminator: terminator)

        
    }
}
