//   File:    SUT.swift
// Project: 
// Package: 
// Product: 
//
// Created by Gene De Lisa on 7/26/22
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
import Swift
import os.log

import XCTest

@testable import hncli


// MARK: - Definition
class StoryTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    
//    func testShouldDecodeFromJSONString() {
//
//        // given
//        let json = """
//    {
//      "id" : "0A20FFB0-888C-47E5-AB53-EF9BEA1B3872",
//      "categories" : [
//        {
//          "id" : "829F53AD-530F-47FB-B54C-2B9502B5FA4E",
//          "categoryName" : "Test",
//          "qna" : [
//            {
//              "id" : "BEF5A520-5AC8-40E1-A341-E6FC96C84FB0",
//              "answerText" : "yup",
//              "value" : 100,
//              "isDailyDouble" : false,
//              "questionText" : "huh"
//            },
//            {
//              "id" : "8CFAA62D-488B-4691-831B-B04CEF8A4921",
//              "answerText" : "nope",
//              "value" : 200,
//              "isDailyDouble" : true,
//              "questionText" : "muh"
//            }
//          ]
//        }
//      ]
//    }
//    """.data(using: .utf8)!
//
//        // when
//        let decoder = JSONDecoder()
//        do {
//            let decoded = try decoder.decode(SUT.self, from: json)
//            print(decoded)
//            print()
//
//            // then
//
//            // insert XCTAssert statements here
//
//            // actual, expected
////            XCTAssertEqual(decoded.count, 1,
////                           """
//// There should be one thingie in the whatchamacallit.
//// Decoded count: \(decoded.count)
//// """)
//
//        } catch {
//            print("error \(error)")
//        }
//    }
    
//    func testShouldDecodeFromJSONFile() {
//
//        // given
//        let showDecoded = true
//
//        let bundle = Bundle(for: type(of: self))
//
//        let basename = "SUT"
//
//        guard let path = bundle.path(forResource: basename, ofType: "json") else {
//            print("could not read json file \(basename).json")
//            XCTFail("could not read json file \(basename).json")
//            return
//        }
//
//        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
//            print("could not create json data from file at path '\(path)'")
//            XCTFail("could not create json data from file at path '\(path)'")
//            return
//        }
//
//        // when
//        do {
//            let decoder = JSONDecoder()
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
//            decoder.dateDecodingStrategy = .formatted(dateFormatter)
//            //decoder.keyDecodingStrategy = .convertFromSnakeCase
//
//            let decoded = try decoder.decode(SUT.self, from: data)
//            if showDecoded {
//                print("\t\(decoded)")
//            }
//
//            // then
//
//            // insert XCTAssert statements here
//
//        } catch let DecodingError.dataCorrupted(context) {
//            print("Decoding Error. The data is corrupted.")
//            print("\(context.debugDescription)")
//            print("Coding Path:")
//            for path in context.codingPath {
//                print(" \(path)")
//            }
//            if let underlying = context.underlyingError {
//                print("\(underlying.localizedDescription)")
//                print("Underlying error: \n\(underlying)")
//            }
//            XCTFail(context.debugDescription)
//        } catch let DecodingError.keyNotFound(key, context) {
//            print("Decoding Error. The key '\(key)' is not found.")
//            print(context.debugDescription)
//            print("Coding Path:")
//            for path in context.codingPath {
//                print(" \(path)")
//            }
//            if let underlying = context.underlyingError {
//                print("\(underlying.localizedDescription)")
//                print("Underlying error: \n\(underlying)")
//            }
//            XCTFail(context.debugDescription)
//        } catch let DecodingError.valueNotFound(value, context) {
//            print("Decoding Error. The value '\(value)' is not found.")
//            print("Value '\(value)' not found:", context.debugDescription)
//            print("Coding Path:")
//            for path in context.codingPath {
//                print(" \(path)")
//            }
//            if let underlying = context.underlyingError {
//                print("\(underlying.localizedDescription)")
//                print("Underlying error: \n\(underlying)")
//            }
//            XCTFail(context.debugDescription)
//        } catch let DecodingError.typeMismatch(type, context) {
//            print("Decoding Error. The type '\(type)' mismatch.")
//            print("Type '\(type)' mismatch:", context.debugDescription)
//            print("Coding Path:")
//            for path in context.codingPath {
//                print(" \(path)")
//            }
//            if let underlying = context.underlyingError {
//                print("\(underlying.localizedDescription)")
//                print("Underlying error: \n\(underlying)")
//            }
//            XCTFail(context.debugDescription)
//        } catch {
//            print("\(error.localizedDescription)")
//            XCTFail("Could not decode \(error)")
//        }
//
//    }
    
//    func testShouldEncodeToJSON() {
//        
//        let sut = SUT()
//        
//        let encoder = JSONEncoder()
//        encoder.outputFormatting = .prettyPrinted
//        
//        var json: Data?
//        do {
//            json = try encoder.encode(sut)
//            XCTAssertNotNil(json)
//            print(json!)
//
//        } catch let EncodingError.invalidValue(type, context) {
//            print("Encoding Error. The type '\(type)' mismatch.")
//            print("Type '\(type)' mismatch:", context.debugDescription)
//            print("Coding Path:")
//            for path in context.codingPath {
//                print(" \(path)")
//            }
//            if let underlying = context.underlyingError {
//                print("\(underlying.localizedDescription)")
//                print("Underlying error: \n\(underlying)")
//            }
//            XCTFail(context.debugDescription)
//
//        } catch {
//            print(error)
//            XCTFail("\(error)")
//        }
//        
//        let s = String(data: json!, encoding: .utf8)
//        XCTAssertNotNil(s, "encoded string should not be nil")
//        
//        if s == nil {
//            XCTFail("encoded string is nil")
//            return
//        }
//        
//        print(s!)
//    }

    
    /// Returns path to the built products directory.
    var productsDirectory: URL {
        #if os(macOS)
        for bundle in Bundle.allBundles where bundle.bundlePath.hasSuffix(".xctest") {
            return bundle.bundleURL.deletingLastPathComponent()
        }
        fatalError("couldn't find the products directory")
        #else
        return Bundle.main.bundleURL
        #endif
    }
    
}
