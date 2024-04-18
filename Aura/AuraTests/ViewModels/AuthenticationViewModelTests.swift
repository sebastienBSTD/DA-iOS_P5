//
//  AuthenticationViewModelTests.swift
//  AuraTests
//
//  Created by Sebastien Bastide on 18/04/2024.
//

import XCTest
@testable import Aura

final class AuthenticationViewModelTests: XCTestCase {

    func test_init_doesNotTriggerLoginUponCreation() {
        let result: Result<(Data, HTTPURLResponse), Error> = .failure(anyNSError())
        let (_, client, _) = makeSUT(result: result, callback: {})

        XCTAssertEqual(client.requests, [])
    }

    func test_login_doesNotTriggerLoginSucceedOnRequestFailed() async {
        let result: Result<(Data, HTTPURLResponse), Error> = .failure(anyNSError())
        var callbackCallCount = 0
        let (sut, _, _) = makeSUT(result: result, callback: { callbackCallCount += 1 })

        await sut.login()

        XCTAssertEqual(callbackCallCount, 0)
    }

    func test_login_doesNotTriggerLoginSucceedOnDeleteTokenStoreFailed() async {
        let item = makeTokenItem()
        let json = makeItemsJSON(item.json)
        let result: Result<(Data, HTTPURLResponse), Error> = .success((json, anyHTTPURLResponse()))
        var callbackCallCount = 0
        let (sut, _, store) = makeSUT(result: result, callback: { callbackCallCount += 1 })

        store.completeDeletion(with: anyNSError())
        await sut.login()

        XCTAssertEqual(store.receivedMessages, [.delete])
        XCTAssertEqual(callbackCallCount, 0)
    }

    func test_login_doesNotTriggerLoginSucceedOnInsertionTokenStoreFailed() async {
        let item = makeTokenItem()
        let json = makeItemsJSON(item.json)
        let result: Result<(Data, HTTPURLResponse), Error> = .success((json, anyHTTPURLResponse()))
        var callbackCallCount = 0
        let (sut, _, store) = makeSUT(result: result, callback: { callbackCallCount += 1 })

        store.completeDeletionSuccessfully()
        store.completeInsertion(with: anyNSError())
        await sut.login()

        XCTAssertEqual(store.receivedMessages, [.delete, .insert])
        XCTAssertEqual(callbackCallCount, 0)
    }

    func test_login_triggersLoginOnSucceedRequestTokenAndStorageTokenCompleted() async {
        let item = makeTokenItem()
        let json = makeItemsJSON(item.json)
        let result: Result<(Data, HTTPURLResponse), Error> = .success((json, anyHTTPURLResponse()))
        var callbackCallCount = 0
        let (sut, _, store) = makeSUT(result: result, callback: { callbackCallCount += 1 })

        store.completeDeletionSuccessfully()
        store.completeDeletionSuccessfully()
        await sut.login()

        XCTAssertEqual(store.receivedMessages, [.delete, .insert])
        XCTAssertEqual(callbackCallCount, 1)
    }

    // MARK: - Helpers

    private func makeSUT(result: Result<(Data, HTTPURLResponse), Error>, callback: @escaping () -> Void) -> (sut: AuthenticationViewModel, client: HTTPClientStub, store: TokenStoreSpy) {
        let client = HTTPClientStub(result: result)
        let authenticator = Authenticator(client: client)
        let tokenStore = TokenStoreSpy()
        let sut = AuthenticationViewModel(authenticator: authenticator, tokenStore: tokenStore, callback)

        return (sut, client, tokenStore)
    }
}
