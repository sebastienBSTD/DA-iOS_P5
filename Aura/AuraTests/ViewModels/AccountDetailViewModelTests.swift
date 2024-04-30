//
//  AccountDetailViewModelTests.swift
//  AuraTests
//
//  Created by Sebastien Bastide on 18/04/2024.
//

import XCTest
@testable import Aura

final class AccountDetailViewModelTests: XCTestCase {

    func test_init_doesNotTriggerLoadAccountDetailsUponCreation() {
        let result: Result<(Data, HTTPURLResponse), Error> = .failure(anyNSError())
        let (sut, client, _) = makeSUT(result: result)

        XCTAssertEqual(client.requests, [])
        XCTAssertEqual(sut.totalAmount, "€12,345.67")
        XCTAssertEqual(sut.allTransactions.count, 3)
    }

    func test_loadAccountDetails_doesNotTriggerLoadAccountDetailsOnRetrieveTokenFailed() async {
        let result: Result<(Data, HTTPURLResponse), Error> = .failure(anyNSError())
        let (sut, _, store) = makeSUT(result: result)

        store.completeRetrieval(with: anyNSError())
        await sut.loadAccountDetails()

        XCTAssertEqual(store.receivedMessages, [.retrieve])
        XCTAssertEqual(sut.totalAmount, "€12,345.67")
        XCTAssertEqual(sut.allTransactions.count, 3)
    }

    func test_loadAccountDetails_doesNotTriggerLoadAccountDetailsOnRequestFailed() async {
        let result: Result<(Data, HTTPURLResponse), Error> = .failure(anyNSError())
        let (sut, _, store) = makeSUT(result: result)

        store.completeRetrieval(with: anyData())
        await sut.loadAccountDetails()

        XCTAssertEqual(store.receivedMessages, [.retrieve])
        XCTAssertEqual(sut.totalAmount, "€12,345.67")
        XCTAssertEqual(sut.allTransactions.count, 3)
    }

    func test_loadAccountDetails_triggersLoadAccountDetailsOnSucceedRequestAccountDetailsAndRetrieveTokenCompleted() async {
        let item = makeAccountDetailsItem()
        let json = makeItemsJSON(item.json)
        let result: Result<(Data, HTTPURLResponse), Error> = .success((json, anyHTTPURLResponse()))
        let (sut, _, store) = makeSUT(result: result)

        store.completeRetrieval(with: anyData())
        await sut.loadAccountDetails()

        XCTAssertEqual(store.receivedMessages, [.retrieve])
        XCTAssertEqual(sut.totalAmount, "€0.0")
        XCTAssertEqual(sut.allTransactions.count, 2)
    }

    // MARK: - Helpers

    private func makeSUT(result: Result<(Data, HTTPURLResponse), Error>) -> (sut: AccountDetailViewModel, client: HTTPClientStub, store: TokenStoreSpy) {
        let client = HTTPClientStub(result: result)
        let loader = AccountDetailsLoader(client: client)
        let tokenStore = TokenStoreSpy()
        let sut = AccountDetailViewModel(loader: loader, tokenStore: tokenStore)

        return (sut, client, tokenStore)
    }
}
