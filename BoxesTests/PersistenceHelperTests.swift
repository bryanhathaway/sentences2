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
    lazy var testablePersistenceHelper = {
        return PersistenceHelper(fileName: "testableFile.json")
    }()

    func testCanRetrieveDefaultFolders() {
        
    }
}
