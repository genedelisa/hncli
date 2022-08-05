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
    
    static func setupColors(foreground: String? = nil, background: String? = nil) {
        ColorConsole.setupColors(foreground: foreground, background: background)
    }

    func clearScreen() {
        Color256.clearScreen()
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
    
    func displayItemBriefly(item: Item) {
        
//        switch item.type {
//        case "comment":
//            print("")
//        case "":
//            print("")
//        default:
//            print("")
//        }
        
        if item.type == "comment" {
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
        }
        
        if let s = item.title {
            //Color256.print(s, fg: .green1, bg: .darkBlue, att: [.bold, .italic])
            ColorConsole.consoleMessage("\(s)")
        }
        if let s = item.url {
            //Color256.print(s, fg: .green, bg: .darkBlue, att: [.italic])
            ColorConsole.consoleMessage("\(s)")
        }
    }
    
    func displayItemFully(item: Item) {
        
        if let s = item.time {
            let t = Date(timeIntervalSince1970: TimeInterval(s))
            let ts = dateFormat.string(from: t)
            ColorConsole.consoleMessage(ts, fg: .green1, bg: .darkBlue, att: [.italic])
            //ColorConsole.consoleMessage(ts)
        }
        
        if let s = item.id {
            ColorConsole.consoleMessage("ID: \(s)")
        }
        
        if let s = item.type {
            ColorConsole.consoleMessage("Type: \(s)")
        }
        
        if let s = item.title {
            // Color256.print(s, fg: .green1, bg: .darkBlue, att: [.italic])
            ColorConsole.consoleMessage(s)
        }
        
        if let s = item.by {
            // Color256.print(s, fg: .green1, bg: .darkBlue, att: [.italic])
            ColorConsole.consoleMessage(s)
        }
        
        if let s = item.text {
            ColorConsole.consoleMessage(s)
        }
        
        if let s = item.url {
            // Color256.print(s, fg: .green1, bg: .darkBlue, att: [.italic])
            ColorConsole.consoleMessage(s)
        }
    }
    
    func displayItemProlix(item: Item) {
        
        if let s = item.time {
            let t = Date(timeIntervalSince1970: TimeInterval(s))
            let ts = dateFormat.string(from: t)
            // Color256.print(ts, fg: .green1, bg: .darkBlue, att: [.italic])
            ColorConsole.consoleMessage(ts)
        }
        
        if let s = item.id {
            ColorConsole.consoleMessage("ID: \(s)")
        }
        if let s = item.parent {
            ColorConsole.consoleMessage("Parent: \(s)")
        }
        
        if let s = item.type {
            ColorConsole.consoleMessage("Type: \(s)")
        }
        
        if let s = item.title {
            // Color256.print(s, fg: .green1, bg: .darkBlue, att: [.italic])
            ColorConsole.consoleMessage("title: \(s)")
        }
        
        if let s = item.by {
            ColorConsole.consoleMessage("by: \(s)")
        }

        if let s = item.descendants {
            ColorConsole.consoleMessage("descendants: \(s)")
        }
        
        if let s = item.kids {
            ColorConsole.consoleMessage("kids: \(s)")
        }
        
        if let s = item.score {
            ColorConsole.consoleMessage("score: \(s)")
        }

        if let s = item.deleted {
            ColorConsole.consoleMessage("deleted: \(s)")
        }

        if let s = item.dead {
            ColorConsole.consoleMessage("dead: \(s)")
        }
        
        if let s = item.poll {
            ColorConsole.consoleMessage("poll: \(s)")
        }
        if let s = item.parts {
            ColorConsole.consoleMessage("parts: \(s)")
        }
        
        if let s = item.text {
            ColorConsole.consoleMessage("Text: \(s)")
        }
        
        if let s = item.url {
            ColorConsole.consoleMessage(s)
        }
    }

    
}
