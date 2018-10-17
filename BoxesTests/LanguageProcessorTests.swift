//
//  LanguageProcessorTests.swift
//  BoxesTests
//
//  Created by Bryan Hathaway on 17/10/18.
//  Copyright © 2018 Bryan Hathaway. All rights reserved.
//

import XCTest
@testable import Boxes

class LanguageProcessorTests: XCTestCase {

    func testProcessesIntoWordsWithoutSpaces() {
        let testSentence = "The cow jumped over the moon"
        let words = LanguageProcessor.words(from: testSentence)

        let expected = ["The", "cow", "jumped", "over", "the", "moon"]
        XCTAssert(expected == words)
    }

    func testProcessesIntoWordsWithSpaces() {
        let testSentence = "The cow jumped over the moon"
        let words = LanguageProcessor.words(from: testSentence, includeWhiteSpace: true)

        let expected = ["The", " ", "cow", " ", "jumped", " ", "over", " ", "the", " ", "moon"]
        XCTAssert(expected == words)
    }

    func testProcessesIntoWordsAndPunctuation() {
        let testSentence = "The cow jumped over the moon."
        let words = LanguageProcessor.words(from: testSentence)

        let expected = ["The", "cow", "jumped", "over", "the", "moon", "."]
        XCTAssert(expected == words)
    }

    func testContractions() {
        let testSentence = "Isn't Don't it's"
        let words = LanguageProcessor.words(from: testSentence)

        let expected = ["Is", "n't", "Do", "n't", "it", "'s"]
        XCTAssert(expected == words)
    }
}
