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


// commandLine: defaults write com.rockhoppertech.hncli thing value
// defaults write com.rockhoppertech.hncli verbose true

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
    
//    struct Key {
//        static let backgroundColorName = "backgroundColorName"
//        static let foregroundColorName = "foregroundColorName"
//    }
    
    // will be in ~/Library/Preferences/hncli.plist

    // static let suiteName = "com.rockhoppertech.hncli"
    // Using your own bundle identifier as an NSUserDefaults suite name does not make sense and will not work. Break on _NSUserDefaults_Log_Nonsensical_Suites to find this
    
    static let suiteName = "hncli"
    
    //var userDefaults = UserDefaults.standard
   // var userDefaults = UserDefaults(suiteName: Self.suiteName)
    
    let userDefaults: UserDefaults
    
    
    init() {
        userDefaults = UserDefaults(suiteName: Self.suiteName)!
        
        registerDefaults()
        
        displayAllInSuite()
        
        //showPreferences()
        
        
//        guard
//            userDefaults != nil
//        else { exit(EXIT_FAILURE) }
        
//        if let dict = UserDefaults.standard.persistentDomain(forName: "com.rockhoppertech.hncli") {
//            print(dict)
//        }

        
//        guard
//            userDefaults != nil
//        else {
//            print("Error getting user defaults for \(Self.suiteName)")
//            exit(EXIT_FAILURE)
//        }
        
        if let ev = envValue(key: "BGCOLOR") {
            print("environment bgcolor: \(ev)")
        }
        
//        userDefaults.register(defaults: [
//            "verbose" : false
//        ] )
//
        //self.verbose = userDefaults.bool(forKey: "verbose")
        //print("user defaults verbose: \(self.verbose)")
        
        //userDefaults.set("red", forKey: Keys.foregroundColorName.rawValue)
        //userDefaults.set("blue", forKey: Keys.backgroundColorName.rawValue)
        
//        addPreference(key: "defaultColor", value: XTColorName.deepPink4)
        

       
    }
    
    
    
    @objc dynamic var numberOfRuns: Int {
        set {
            userDefaults.set(newValue, forKey: Keys.numberOfRuns.rawValue)
        }
        get {
            userDefaults.integer(forKey: Keys.numberOfRuns.rawValue)
        }
    }

    @objc dynamic var foregroundColorName: String? {
        set {
            userDefaults.set(newValue, forKey: Keys.foregroundColorName.rawValue)
        }
        get {
            userDefaults.string(forKey: Keys.foregroundColorName.rawValue)
        }
    }
    
    @objc dynamic var backgroundColorName: String? {
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

    @objc dynamic var firstRunDate: Date? {
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
            Keys.numberOfRuns.rawValue: 0,
            Keys.firstRunDate.rawValue: 0
        ])
    }
    
    
    
    func addPreference(key: String, value: Encodable) {
        //precondition(userDefaults != nil)
//        guard let defaults = userDefaults else {
//            print("Cannot create user defaults")
//            return
//        }
        let defaults = userDefaults
        

        let data = try? PropertyListEncoder().encode(value)
        defaults.set(data, forKey: key)
    }

    func encodeColorName(key: String, value: XTColorName) {
//        guard let defaults = userDefaults else {
//            print("Cannot create user defaults")
//            return
//        }
        let defaults = userDefaults

        let data = try? PropertyListEncoder().encode(value)
        defaults.set(data, forKey: key)
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
            print("\(value)")
            return value
        }
        print("no env value for key \(key)")
        return nil
    }

    func showPreferences() {
        print("\(#function)")

        print("All preferences")
        let dict = userDefaults.dictionaryRepresentation()
        for (k,v) in dict {
            print("\(k) : \(v)")
        }
    }
    
    func displayAllInSuite() {
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

}

//public let UserDefaultsSuiteName = "com.rockhoppertech.hncli"
//public let defaults = UserDefaults(suiteName: UserDefaultsSuiteName)!

//public extension UserDefaults {
//
//    // probably not the right place for this?
//    //var UserDefaultsSuiteName: String { "com.rockhoppertech.hncli" }
//
//    enum Keys: String, CaseIterable {
//        case firstRunDate = "first-run-date"
//        case numberOfRuns = "number-of-runs"
//        case foregroundColorName = "foreground-color-name"
//        case backgroundColorName = "background-color-name"
//        case fetchLimit = "fetch-limit"
//        case verbose
//        case brief
//    }
//
//    func displayAll() {
//        for (k,v) in self.dictionaryRepresentation() {
//            print("\(k) : \(v)")
//        }
//    }
//
//    func displayAllInSuite() {
//        print("suiteName: \(UserDefaultsSuiteName)")
//
//        if let dict = persistentDomain(forName: UserDefaultsSuiteName) {
//            for (k,v) in dict {
//                print("\(k) : \(v)")
//            }
//        }
//    }
//
//
//    func resetAll() {
//        //UserDefaults.standard.removePersistentDomain(forName: bundleID)
//
//        Keys.allCases.forEach { removeObject(forKey: $0.rawValue) }
//        defaults.synchronize()
//    }
//
//    func unset(key: Keys) {
//        removeObject(forKey: key.rawValue)
//        defaults.synchronize()
//    }
//
//
//    @objc dynamic var numberOfRuns: Int {
//        set {
//            set(newValue, forKey: Keys.numberOfRuns.rawValue)
//        }
//        get {
//            integer(forKey: Keys.numberOfRuns.rawValue)
//        }
//    }
//
//    @objc dynamic var foregroundColorName: String? {
//        set {
//            set(newValue, forKey: Keys.foregroundColorName.rawValue)
//        }
//        get {
//            string(forKey: Keys.foregroundColorName.rawValue)
//        }
//    }
//
//    @objc dynamic var backgroundColorName: String? {
//        set {
//            set(newValue, forKey: Keys.backgroundColorName.rawValue)
//        }
//        get {
//            string(forKey: Keys.backgroundColorName.rawValue)
//        }
//    }
//
//
//
//    @objc dynamic var verbose: String? {
//        set {
//            set(newValue, forKey: Keys.verbose.rawValue)
//        }
//        get {
//            string(forKey: Keys.verbose.rawValue)
//        }
//    }
//
//    var brief: Bool? {
//        set {
//            set(newValue, forKey: Keys.brief.rawValue)
//        }
//        get {
//            bool(forKey: Keys.brief.rawValue)
//        }
//    }
//
//    @objc dynamic var firstRunDate: Date? {
//        set {
//            set(newValue, forKey: Keys.firstRunDate.rawValue)
//        }
//        get {
//            object(forKey: Keys.firstRunDate.rawValue) as? Date
//        }
//    }
//
//    func isFirstRun() -> Bool {
//
//        if firstRunDate == nil {
//            firstRunDate = Date()
//            return true
//        }
//
//        return false
//    }
//
//    // MARK: Default Values
//
//    func registerDefaults() {
//
//        self.register(defaults: [
//            Keys.foregroundColorName.rawValue: "",
//            Keys.backgroundColorName.rawValue: "",
//            Keys.verbose.rawValue: "",
//            Keys.numberOfRuns.rawValue: 0
//        ])
//    }
//
//}
