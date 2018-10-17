//
//  PersistenceHelperTests.swift
//  BoxesTests
//
//  Created by Bryan Hathaway on 17/10/18.
//  Copyright © 2018 Bryan Hathaway. All rights reserved.
//

import XCTest
@testable import Boxes

class PersistenceHelperTests: XCTestCase {
    lazy var testableHelper = {
        return PersistenceHelper(fileNameWithExtension: "testableFile.json")
    }()

    func testCanRetrieveDefaultFolders() {
        let helper = PersistenceHelper.default

        let folders = try? helper.read()

        XCTAssert(folders?.first?.title == "Class 1")
        XCTAssert(folders?.first?.sentences.first?.title == "Alice in Wonderland")
    }

    func testCanSaveAndReadData() {
        let testPhrase = Phrase(value: "Test Phrase", color: .white)
        let testSentence = Sentence(title: "Test Sentence",
                                    compiledSentence: "Test Phrase",
                                    phrases: [testPhrase],
                                    color: .blue)

        let testFolder = Folder(title: "Test Folder", sentences: [testSentence], color: .white)

        do {
            try testableHelper.save(folders: [testFolder])

            let folders = try testableHelper.read()
            XCTAssert(folders == [testFolder])

        } catch {
            XCTAssert(false)
        }

        XCTAssert(true)
    }
    
    override func tearDown() {
        super.tearDown()
        try? testableHelper.delete()
    }

}
