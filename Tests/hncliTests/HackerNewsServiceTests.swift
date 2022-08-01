// File:    HackerNewsServiceTests.swift
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

@testable import hncli
import os.log
import XCTest

final class HackerNewsServiceTests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFetchNewStoryIDs() async {
        let api = HackerNewsAPIService()

        do {
//            let IDs = try await api.fetchNewStoryIDs()
            let IDs = try await api.fetchIDs(kind: .newstories)
            XCTAssertNotNil(IDs, "is not nil")

            Logger.testing.debug("\(IDs)")

            XCTAssertGreaterThan(IDs.count, 0, "that there are actual IDs returned")

        } catch {
            Logger.testing.error("\(error.localizedDescription)")
        }
    }

    func xtestFetchNewStory() async {
        let api = HackerNewsAPIService()

        do {
            let IDs = try await api.fetchIDs(kind: .newstories)

            Logger.testing.info("\(IDs)")
            XCTAssertGreaterThan(IDs.count, 0, "that there are actual IDs returned")

            let id = IDs[0]
            let story = try await api.fetchItem(id: id)
            Logger.testing.info("story: \(story.title!)")
            XCTAssertGreaterThan(story.title!.count, 0, "that there is an actual title in the story")

        } catch {
            Logger.testing.error("\(error.localizedDescription)")
        }
    }

    func testFetchTopStories() async {
        let api = HackerNewsAPIService()

        do {
            let stories = try await api.fetchStories(kind: .topstories)

            Logger.testing.info("story count: \(stories.count)")
            XCTAssertGreaterThan(stories.count, 0, "that there are actual IDs returned")

            for story in stories {
                XCTAssertNotNil(story.title)
                Logger.testing.info("story: \(story.title!)")
                XCTAssertGreaterThan(story.title!.count, 0, "that there is an actual title in the story")
            }

        } catch {
            Logger.testing.error("\(error.localizedDescription)")
        }
    }

    func testFetchStory() async {
        let api = HackerNewsAPIService()

        do {
            let story = try await api.fetchItem(id: 32_241_130)
            Logger.testing.debug("\(story)")

        } catch {
            Logger.testing.error("\(error.localizedDescription)")
        }
    }

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
            let decoded = try decoder.decode(Story.self, from: json)
            print(decoded)
            print()

            // then

            // insert XCTAssert statements here

            // actual, expected
            //            XCTAssertEqual(decoded.count, 1,
            //                           """
            // There should be one thingie in the whatchamacallit.
            // Decoded count: \(decoded.count)
            // """)

        } catch {
            print("error \(error)")
        }
    }
}
