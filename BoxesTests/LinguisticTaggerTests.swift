//
//  LinguisticTaggerTests.swift
//  BoxesTests
//
//  Created by Bryan Hathaway on 17/10/18.
//  Copyright © 2018 Bryan Hathaway. All rights reserved.
//

import XCTest
@testable import Boxes

class LinguisticTaggerTests: XCTestCase {

    func test() {
        let testSentence = "The cow jumped over the moon"
        let words = LanguageProcessor.words(from: testSentence)

        let expected = ["The", "cow", "jumped", "over", "the", "moon"]
        XCTAssert(expected == words)
    }

}
