// File:    Preferences.swift
// Project: hncli
//
// Created by Gene De Lisa on 8/2/22
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
import OSLog

class Preferences {
    static let sharedInstance = Preferences()
    
    enum Keys: String, CaseIterable {
        case firstRunDate = "first-run-date"
        case numberOfRuns = "number-of-runs"
        case foregroundColorName = "foreground-color-name"
        case backgroundColorName = "background-color-name"
        case fetchLimit = "fetch-limit"
        case verbose
        case brief
    }
    
    // will be in ~/Library/Preferences/hncli.plist
    
    static let suiteName = "hncli"
    
    let userDefaults: UserDefaults
    
    init() {
        guard
            let defaults = UserDefaults(suiteName: Self.suiteName)
        else { exit(EXIT_FAILURE) }
        self.userDefaults = defaults
        
        registerDefaults()
    }
    
    var numberOfRuns: Int {
        set {
            userDefaults.set(newValue, forKey: Keys.numberOfRuns.rawValue)
        }
        get {
            userDefaults.integer(forKey: Keys.numberOfRuns.rawValue)
        }
    }
    
    var fetchLimit: Int {
        set {
            userDefaults.set(newValue, forKey: Keys.fetchLimit.rawValue)
        }
        get {
            userDefaults.integer(forKey: Keys.fetchLimit.rawValue)
        }
    }
    
    var foregroundColorName: String? {
        set {
            userDefaults.set(newValue, forKey: Keys.foregroundColorName.rawValue)
        }
        get {
            userDefaults.string(forKey: Keys.foregroundColorName.rawValue)
        }
    }
    
    var backgroundColorName: String? {
        set {
            userDefaults.set(newValue, forKey: Keys.backgroundColorName.rawValue)
        }
        get {
            userDefaults.string(forKey: Keys.backgroundColorName.rawValue)
        }
    }
    
    var verbose: Bool {
        set {
            userDefaults.set(newValue, forKey: Keys.verbose.rawValue)
        }
        get {
            userDefaults.bool(forKey: Keys.verbose.rawValue)
        }
    }
    
    var brief: Bool {
        set {
            userDefaults.set(newValue, forKey: Keys.brief.rawValue)
        }
        get {
            userDefaults.bool(forKey: Keys.brief.rawValue)
        }
    }
    
    // @objc dynamic
    var firstRunDate: Date? {
        set {
            userDefaults.set(newValue, forKey: Keys.firstRunDate.rawValue)
        }
        get {
            userDefaults.object(forKey: Keys.firstRunDate.rawValue) as? Date
        }
    }
    
    func isFirstRun() -> Bool {
        
        if firstRunDate == nil {
            firstRunDate = Date()
            return true
        }
        
        return false
    }
    
    // MARK: Default Values
    
    func registerDefaults() {
        print("registering defaults")
        userDefaults.register(defaults: [
            Keys.foregroundColorName.rawValue: "gold1",
            Keys.backgroundColorName.rawValue: "blue",
            Keys.verbose.rawValue: false,
            Keys.brief.rawValue: true,
            Keys.fetchLimit.rawValue: 5,
            Keys.numberOfRuns.rawValue: 0,
            Keys.firstRunDate.rawValue: 0
        ])
    }
    
    // this takes a lot of time. Find a better way.
    func addEncodedPreference(key: String, value: Encodable) {
        let data = try? PropertyListEncoder().encode(value)
        userDefaults.set(data, forKey: key)
    }
    
    func encodeColorName(key: String, value: XTColorName) {
        let data = try? PropertyListEncoder().encode(value)
        userDefaults.set(data, forKey: key)
    }
    
    func decodeColorName(data: Data) -> XTColorName? {
        do {
            let value = try PropertyListDecoder().decode(XTColorName.self, from: data)
            return value
        } catch {
            print(error)
            return nil
        }
    }
    
    // zsh: typeset -x BGCOLOR=foo
    // bash: export BGCOLOR=foo
    func envValue(key: String) -> String? {
        if let value = ProcessInfo.processInfo.environment[key]  {
            return value
        }
        Logger.ui.error("no env value for key \(key)")
        return nil
    }
    
    func printPreferences() {
        print("\(#function)")
        
        print("All preferences")
        let dict = userDefaults.dictionaryRepresentation()
        for (k,v) in dict {
            print("\(k) : \(v)")
        }
    }
    
    func printAllInSuite() {
        print("\(#function)")
        
        print("suiteName: \(Self.suiteName)")
        
        if let dict = userDefaults.persistentDomain(forName: Self.suiteName) {
            for (k,v) in dict {
                print("\(k) : \(v)")
            }
        }
    }
    
    func resetAll() {
        //UserDefaults.standard.removePersistentDomain(forName: bundleID)
        Keys.allCases.forEach { userDefaults.removeObject(forKey: $0.rawValue) }
        userDefaults.synchronize()
    }
    
    static func resetDefaults() {
        if let bundleID = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleID)
            return
        }
        if let bundleID = Bundle.module.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleID)
            return
        }
    }
    
}
