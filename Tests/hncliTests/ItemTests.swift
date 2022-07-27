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
import XCTest
import os.log
@testable import hncli

final class ItemTests: XCTestCase {
    
    
    func testShouldDecodeFromJSONString() {
        
        // given
        let json = """
    {
    "by":"hochmartinez",
    "descendants":0,
    "id":32241130,
    "score":2,
    "time":1658856172,
    "title":"A climate scientist explains the record-breaking heatwave engulfing Europe",
    "type":"story",
    "url":"https://mashable.com/video/heatwave-wildfires-europe-climate-global-warming-faster"
    }
    """.data(using: .utf8)!
        
        // when
        let decoder = JSONDecoder()
        do {
            let decoded = try decoder.decode(Item.self, from: json)
            print(decoded)
            print()
            
            // then
            
            // actual, expected
            XCTAssertEqual(decoded.id, 32241130, "the id should match")
            
            
        } catch {
            print("error \(error)")
        }
    }
    
    func testShouldEncodeToJSON() {
        
        // given

        let item = Item(by: "me", descendants: nil, id: 123, kids: nil, score: 1, time: 100000, title: "the title",
                        type: "story", url: "http://apple.com/", deleted: nil, text: "hey there", dead: nil, parent: nil,
                        poll: nil, parts: nil)
        
        // when
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        var jsonAsData: Data?
        do {
            jsonAsData = try encoder.encode(item)
        } catch let EncodingError.invalidValue(type, context) {
            print("Encoding Error. The type '\(type)' mismatch.")
            print("Type '\(type)' mismatch:", context.debugDescription)
            print("Coding Path:")
            for path in context.codingPath {
                print(" \(path)")
            }
            if let underlying = context.underlyingError {
                print("\(underlying.localizedDescription)")
                print("Underlying error: \n\(underlying)")
            }
            XCTFail(context.debugDescription)
            
        } catch {
            print(error)
            XCTFail("\(error)")
        }
        
        // then
        XCTAssertNotNil(jsonAsData)
        
        let json = String(data: jsonAsData!, encoding: .utf8)
        XCTAssertNotNil(json, "encoded string should not be nil")
        
        if json == nil {
            XCTFail("encoded string is nil")
            return
        }
        
        print(json!)

    }
    
    
}
