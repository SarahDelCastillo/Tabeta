//
//  LocalTaskLoaderTests.swift
//  TabetaTests
//
//  Created by Sarah Del Castillo on 03/05/2023.
//

import XCTest
@testable import Tabeta

final class LocalTaskLoaderTests: XCTestCase {

    func test_initDoesNotSendMessages() {
        let (_, spy) = makeSUT()
        XCTAssertTrue(spy.receivedMessages.count == 0)
    }
    
    func test_loadSendsOnlyLoadMessage() async {
        let (sut, spy) = makeSUT()
        let _ = try! await sut.loadTasks()
        XCTAssertTrue(spy.receivedMessages.count == 1)
        XCTAssertEqual(spy.receivedMessages.first!, .load)
    }
    
    func test_loadReturnsEmptyArrayOnEmptyData() async {
        let (sut, _) = makeSUT()
        let result = try! await sut.loadTasks()
        XCTAssertEqual(result, [])
    }
    
    func test_loadReturnsCorrectData() async {
        let (sut, spy) = makeSUT()
        let testTasks = makeTestTasks()
        spy.setTestTasks(tasks: testTasks)
        
        let result = try! await sut.loadTasks()
        XCTAssertEqual(result, testTasks)
    }
    
    private func makeSUT() -> (LocalTaskLoader, TaskLoaderSpy) {
        let spy = TaskLoaderSpy()
        let sut = LocalTaskLoader(taskLoader: spy)
        trackForMemoryLeaks(spy)
        trackForMemoryLeaks(sut)
        return (sut, spy)
    }
    
    private func makeTestTasks() -> [TabeTask] {
        let task1 = TabeTask(done: true, name: "task1", notifTimes: [1, 2])
        let task2 = TabeTask(done: false, name: "task2", notifTimes: [3, 4])
        return [task1, task2]
    }
}

final private class TaskLoaderSpy: TabeTaskLoader {
    enum ReceivedMessage: Equatable {
        case load
    }
    
    private(set) var receivedMessages = [ReceivedMessage]()
    private(set) var tasks = [TabeTask]()
    
    func setTestTasks(tasks: [TabeTask]) {
        self.tasks = tasks
    }
    
    func loadTasks() async throws -> [TabeTask] {
        receivedMessages.append(.load)
        return tasks
    }
}
