//
//  MoneyTransferViewModelTests.swift
//  AuraTests
//
//  Created by Sebastien Bastide on 18/04/2024.
//

import XCTest
@testable import Aura

final class MoneyTransferViewModelTests: XCTestCase {

    func test_init_doesNotTriggerSendMoneyUponCreation() {
        let result: Result<(Data, HTTPURLResponse), Error> = .failure(anyNSError())
        let (sut, client, _) = makeSUT(result: result)

        XCTAssertEqual(client.requests, [])
        XCTAssertEqual(sut.recipient, "")
        XCTAssertEqual(sut.amount, "")
        XCTAssertEqual(sut.transferMessage, "")
    }

    func test_init_doesNotTriggerSendMoneyOnInvalidFields() async {
        let result: Result<(Data, HTTPURLResponse), Error> = .failure(anyNSError())
        let (sut, _, _) = makeSUT(result: result)

        sut.recipient = "non email"
        sut.amount = "0.1"
        await sut.sendMoney()

        XCTAssertEqual(sut.transferMessage, "Please enter a correct recipient and amount.")

        sut.recipient = "anemail@email.com"
        sut.amount = ""
        await sut.sendMoney()

        XCTAssertEqual(sut.transferMessage, "Please enter a correct recipient and amount.")

        sut.recipient = "0600000000"
        sut.amount = ""
        await sut.sendMoney()

        XCTAssertEqual(sut.transferMessage, "Please enter a correct recipient and amount.")
    }

    func test_init_doesNotTriggerSendMoneyOnRetrieveTokenFailed() async {
        let result: Result<(Data, HTTPURLResponse), Error> = .failure(anyNSError())
        let (sut, _, store) = makeSUT(result: result)

        sut.recipient = "anemail@email.com"
        sut.amount = "0.1"
        store.completeRetrieval(with: anyNSError())
        await sut.sendMoney()

        XCTAssertEqual(store.receivedMessages, [.retrieve])
        XCTAssertEqual(sut.transferMessage, "Transfert failed")
    }

    func test_init_doesNotTriggerSendMoneyOnRequestFailed() async {
        let result: Result<(Data, HTTPURLResponse), Error> = .failure(anyNSError())
        let (sut, _, store) = makeSUT(result: result)

        sut.recipient = "anemail@email.com"
        sut.amount = "0.1"
        store.completeRetrieval(with: anyData())
        await sut.sendMoney()

        XCTAssertEqual(store.receivedMessages, [.retrieve])
        XCTAssertEqual(sut.transferMessage, "Transfert failed")
    }

    func test_init_triggersSendMoneyOnSucceedRequestAccountDetailsAndRetrieveTokenCompleted() async {
        let result: Result<(Data, HTTPURLResponse), Error> = .success((anyData(), anyHTTPURLResponse()))
        let (sut, _, store) = makeSUT(result: result)

        sut.recipient = "anemail@email.com"
        sut.amount = "0.1"
        store.completeRetrieval(with: anyData())
        await sut.sendMoney()

        XCTAssertEqual(store.receivedMessages, [.retrieve])
        XCTAssertEqual(sut.transferMessage, "Successfully transferred \(sut.amount) to \(sut.recipient)")
    }

    // MARK: - Helpers

    private func makeSUT(result: Result<(Data, HTTPURLResponse), Error>) -> (sut: MoneyTransferViewModel, client: HTTPClientStub, store: TokenStoreSpy) {
        let client = HTTPClientStub(result: result)
        let sender = MoneyTransfertSender(client: client)
        let tokenStore = TokenStoreSpy()
        let sut = MoneyTransferViewModel(sender: sender, tokenStore: tokenStore)

        return (sut, client, tokenStore)
    }
}
