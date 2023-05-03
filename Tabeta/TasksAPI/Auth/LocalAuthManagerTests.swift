//
//  LocalAuthManagerTests.swift
//  TabetaTests
//
//  Created by Sarah Del Castillo on 02/05/2023.
//

import XCTest

@testable import Tabeta

final class LocalAuthManagerTests: XCTestCase {
    func test_initDoesNotSendAnyMessage() {
        let (_, authSpy, _) = makeSUT()
        XCTAssertTrue(authSpy.receivedMessages.count == 0)
    }
    
    //MARK: Create -
    func test_createSendsOnlyCreateMessage() async {
        let (sut, authSpy, _) = makeSUT()
        let credentials = makeAnyUserCredentials()
        
        try! await sut.createUser(with: credentials)
        XCTAssertTrue(authSpy.receivedMessages.count == 1)
        XCTAssertEqual(authSpy.receivedMessages.first!, .createUser(credentials))
    }
    
    func test_createDoesNotCreateUser() async {
        let (sut, _, userDef) = makeSUT()
        let credentials = makeAnyUserCredentials()
        
        try! await sut.createUser(with: credentials)
        XCTAssertFalse(userDef.userExists)
    }
    
    //MARK: Sign in -
    func test_signInSendsOnlySignInMessage() async {
        let (sut, authSpy, _) = makeSUT()
        let credentials = makeAnyUserCredentials()
        
        try! await sut.signIn(with: credentials)
        XCTAssertTrue(authSpy.receivedMessages.count == 1)
        XCTAssertEqual(authSpy.receivedMessages.first!, .signIn(credentials))
    }
    
    func test_signInSetsUserUid() async {
        let (sut, _, userDefSpy) = makeSUT()
        let credentials = makeAnyUserCredentials()
        
        try! await sut.signIn(with: credentials)
        XCTAssertEqual(userDefSpy.userId, "Any UID")
    }
    
    func test_signInSetsLoggedIn() async {
        let (sut, authSpy, _) = makeSUT()
        let credentials = makeAnyUserCredentials()
        
        try! await sut.signIn(with: credentials)
        XCTAssertTrue(authSpy.isLoggedIn)
    }
    
    func test_signInSetsUserExists() async {
        let (sut, _, userDefSpy) = makeSUT()
        let credentials = makeAnyUserCredentials()
        
        try! await sut.signIn(with: credentials)
        XCTAssertTrue(userDefSpy.userExists)
    }
    
    //MARK: Log out -
    func test_logoutSendsOnlyLogoutMessage() {
        let (sut, spy, _) = makeSUT()
        
        try!  sut.logout()
        XCTAssertTrue(spy.receivedMessages.count == 1)
        XCTAssertEqual(spy.receivedMessages.first!, .logout)
    }
    
    func test_logoutClearsUserDefaults() {
        let (sut, _, userDef) = makeSUT()
        
        try!  sut.logout()
        XCTAssertNil(userDef.userId)
        XCTAssertFalse(userDef.userExists)
    }
    
    private func makeSUT() -> (sut: LocalAuthManager, authSpy: AuthManagerSpy, userDefSpy: UserDefaultsSpy) {
        let authSpy = AuthManagerSpy()
        let userDefSpy = UserDefaultsSpy()
        let sut = LocalAuthManager(authManager: authSpy, userDefaults: userDefSpy)
        trackForMemoryLeaks(authSpy)
        trackForMemoryLeaks(sut)
        trackForMemoryLeaks(userDefSpy)
        return (sut, authSpy, userDefSpy)
    }
    
    private func makeAnyUserCredentials() -> UserCredentials {
        UserCredentials(email: "any@email.com", password: "anyPassword")
    }
}

//MARK: Helpers -
private final class AuthManagerSpy: TabetaAuthManager {
    enum ReceivedMessage: Equatable {
        static func == (lhs: ReceivedMessage, rhs: ReceivedMessage) -> Bool {
            switch (lhs, rhs) {
            case (.createUser(let lhsValue), .createUser(let rhsValue)),
                (.signIn(let lhsValue), .signIn(let rhsValue)):
                return lhsValue == rhsValue
            case (.logout, .logout):
                return true
            default:
                return false
            }
        
        }
        
        case createUser(UserCredentials)
        case signIn(UserCredentials)
        case logout
    }
    
    var isLoggedIn = false
    var userUid: String?
    private(set) var receivedMessages = [ReceivedMessage]()
    
    func createUser(with credentials: UserCredentials) async throws {
        receivedMessages.append(.createUser(credentials))
        isLoggedIn = true
        userUid = "Any UID"
    }
    
    func signIn(with credentials: UserCredentials) async throws {
        receivedMessages.append(.signIn(credentials))
        isLoggedIn = true
        userUid = "Any UID"
    }
    
    func logout() throws {
        receivedMessages.append(.logout)
        isLoggedIn = false
        userUid = nil
    }
}

final class UserDefaultsSpy: UserDefaultsProtocol {
    var userId: String?
    var userExists = false
}
