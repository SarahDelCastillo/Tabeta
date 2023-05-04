//
//  TabeTaskTests.swift
//  TabetaTests
//
//  Created by Sarah Del Castillo on 04/05/2023.
//

import XCTest
@testable import Tabeta

final class TabeTaskTests: XCTestCase {

    func test_dictionnaryValueContainsExpectedValues() {
        let testTask = TabeTask(identifier: "testId", done: true, name: "testName", notifTimes: [1,2])
        let testedDict = testTask.dictionaryValue
        
        XCTAssertTrue(testedDict.count == 4)
        
        let testedIdentifier = testedDict["identifier"] as? String
        XCTAssertNotNil(testedIdentifier)
        XCTAssertEqual(testedIdentifier, "testId")
        
        let testedDone = testedDict["done"] as? Bool
        XCTAssertNotNil(testedDone)
        XCTAssertTrue(testedDone!)
        
        let testedName = testedDict["name"] as? String
        XCTAssertNotNil(testedName)
        XCTAssertEqual(testedName, "testName")
        
        let testedNotifTimes = testedDict["notifTimes"] as? [String: Bool]
        XCTAssertNotNil(testedNotifTimes)
        XCTAssertTrue(testedNotifTimes!.count == 2)
        XCTAssertEqual(testedNotifTimes, ["1": true, "2": true])
    }

}
