//
//  LocalGroupManagerTests.swift
//  TabetaTests
//
//  Created by Sarah Del Castillo on 03/05/2023.
//

import XCTest
@testable import Tabeta

final class LocalGroupManagerTests: XCTestCase {
    
    func test_initDoesNotSendAnyMessage() {
        let (_, spy) = makeSUT()
        XCTAssertTrue(spy.receivedMessages.count == 0)
    }
    
    func test_createGroupSendsOnlyCreateGroupMessage() {
        let (sut, spy) = makeSUT()
        
        sut.createGroup()
        XCTAssertTrue(spy.receivedMessages.count == 1)
        XCTAssertEqual(spy.receivedMessages.first!, .createGroup)
    }
    
    func test_createUserSendsOnlyCreateUserMessage() {
        let (sut, spy) = makeSUT()
        
        sut.createUser(name: "any user")
        XCTAssertTrue(spy.receivedMessages.count == 1)
        XCTAssertEqual(spy.receivedMessages.first!, .createUser("any user"))
    }
    
    func test_joinGroupSendsOnlyJoinGroupMessage() {
        let (sut, spy) = makeSUT()
        
        sut.joinGroup(groupId: "any group")
        XCTAssertTrue(spy.receivedMessages.count == 1)
        XCTAssertEqual(spy.receivedMessages.first!, .joinGroup("any group"))
    }
    
    func test_groupExistsSendsOnlyGroupExistsMessage() async {
        let (sut, spy) = makeSUT()
        
        let _ = await sut.groupExists(groupId: "any group")
        XCTAssertTrue(spy.receivedMessages.count == 1)
        XCTAssertEqual(spy.receivedMessages.first!, .groupExists("any group"))
    }
    
    func test_groupExistsReturnsFalseWhenGroupDoesNotExist() async {
        let (sut, spy) = makeSUT()
        spy.fakeGroupId(id: "")
        
        let result = await sut.groupExists(groupId: "any group")
        XCTAssertFalse(result)
    }
    
    func test_groupExistsReturnsTrueWhenGroupExists() async {
        let (sut, spy) = makeSUT()
        spy.fakeGroupId(id: "any group")
        
        let result = await sut.groupExists(groupId: "any group")
        XCTAssertTrue(result)
    }
    
    private func makeSUT() -> (LocalGroupManager, GroupManagerSpy) {
        let spy = GroupManagerSpy()
        let sut = LocalGroupManager(groupManager: spy)
        trackForMemoryLeaks(spy)
        trackForMemoryLeaks(sut)
        return (sut, spy)
    }
}

private class GroupManagerSpy: TabetaGroupManager {
    enum ReceivedMessage: Equatable {
        
        static func == (lhs: ReceivedMessage, rhs: ReceivedMessage) -> Bool {
            switch (lhs, rhs) {
            case (.createGroup, .createGroup): return true
            case (.createUser(let lhsValue), .createUser(let rhsValue)):
                fallthrough
            case (.joinGroup(let lhsValue), .joinGroup(let rhsValue)):
                fallthrough
            case (.groupExists(let lhsValue), .groupExists(let rhsValue)):
                return lhsValue == rhsValue
            default: return false
            }
        }
        
        case createGroup
        case createUser(String)
        case joinGroup(String)
        case groupExists(String)
    }
    
    private(set) var receivedMessages = [ReceivedMessage]()
    private var groupId = ""
    func fakeGroupId(id: String) { groupId = id }
    
    func createGroup() {
        receivedMessages.append(.createGroup)
    }
    
    func createUser(name: String) {
        receivedMessages.append(.createUser(name))
    }
    
    func joinGroup(groupId: String) {
        receivedMessages.append(.joinGroup(groupId))
    }
    
    func groupExists(groupId: String) async -> Bool {
        receivedMessages.append(.groupExists(groupId))
        return groupId == self.groupId
    }
}
