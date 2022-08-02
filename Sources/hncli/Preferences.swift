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

struct Preferences {
    static let sharedInstance = Preferences()
    
    // will be in ~/Library/Preferences/hncli.plist

    // static let suiteName = "com.rockhoppertech.hncli"
    // Using your own bundle identifier as an NSUserDefaults suite name does not make sense and will not work. Break on _NSUserDefaults_Log_Nonsensical_Suites to find this
    
    static let suiteName = "hncli"
    
    var userDefaults = UserDefaults.standard
//    var userDefaults = UserDefaults(suiteName: Self.suiteName)
    
    var verbose = false
    
    init() {
        
//        guard
//            userDefaults != nil
//        else {
//            print("Error getting user defaults for \(Self.suiteName)")
//            exit(EXIT_FAILURE)
//        }
        
        if let ev = envValue(key: "BGCOLOR") {
            print("environment bgcolor: \(ev)")
        }
        
        userDefaults.register(defaults: [
            "verbose" : false
        ] )
        
        self.verbose = userDefaults.bool(forKey: "verbose")
        print("user defaults verbose: \(self.verbose)")
        
        
        addPreference(key: "defaultColor", value: XTColorName.deepPink4)
        
        showPreferences()
        
       
    }
    
    func showPreferences() {
        print("All preferences")
        let dict = userDefaults.dictionaryRepresentation()
        for (k,v) in dict {
            print("\(k) : \(v)")
        }
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

    
}
