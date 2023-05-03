//
//  LocalTaskManagerTests.swift
//  TabetaTests
//
//  Created by Sarah Del Castillo on 03/05/2023.
//

import XCTest
@testable import Tabeta

final class LocalTaskManagerTests: XCTestCase {
    
    func test_initDoesNotSendMessages() {
        let (_, spy) = makeSUT()
        XCTAssertTrue(spy.receivedMessages.count == 0)
    }
    
    func test_createSendsOnlyCreateMessage() async {
        let (sut, spy) = makeSUT()
        let task = makeAnyTask()
        try! await sut.create(task: task)
        
        XCTAssertTrue(spy.receivedMessages.count == 1)
        XCTAssertEqual(spy.receivedMessages.first!, .create(task))
    }
    
    func test_updateSendsOnlyUpdateMessage() async {
        let (sut, spy) = makeSUT()
        let task = makeAnyTask()
        try! await sut.update(task: task)
        
        XCTAssertTrue(spy.receivedMessages.count == 1)
        XCTAssertEqual(spy.receivedMessages.first!, .update(task))
    }
    
    func test_deleteSendsOnlyDeleteMessage() async {
        let (sut, spy) = makeSUT()
        let task = makeAnyTask()
        try! await sut.delete(task: task)
        
        XCTAssertTrue(spy.receivedMessages.count == 1)
        XCTAssertEqual(spy.receivedMessages.first!, .delete(task))
    }
    
    private func makeSUT() -> (LocalTaskManager, TaskManagerSpy) {
        let spy = TaskManagerSpy()
        let sut = LocalTaskManager(taskManager: spy)
        trackForMemoryLeaks(spy)
        trackForMemoryLeaks(sut)
        return (sut, spy)
    }
    
    private func makeAnyTask() -> TabeTask {
        TabeTask(done: false, name: "any name", notifTimes: [1, 2])
    }
}

private final class TaskManagerSpy: TabeTaskManager {
    enum ReceivedMessage: Equatable {
        static func == (lhs: TaskManagerSpy.ReceivedMessage, rhs: TaskManagerSpy.ReceivedMessage) -> Bool {
            switch (lhs, rhs) {
            case (.create(let lhsValue), .create(let rhsValue)):
                fallthrough
            case (.delete(let lhsValue), .delete(let rhsValue)):
                fallthrough
            case (.update(let lhsValue), .update(let rhsValue)):
                return lhsValue == rhsValue
            default: return false
            }
        }
        
        case create(TabeTask)
        case update(TabeTask)
        case delete(TabeTask)
    }
    
    private(set) var receivedMessages = [ReceivedMessage]()
    func create(task: TabeTask) async throws {
        receivedMessages.append(.create(task))
    }
    
    func update(task: TabeTask) async throws {
        receivedMessages.append(.update(task))
    }
    
    func delete(task: TabeTask) async throws {
        receivedMessages.append(.delete(task))
    }
}
