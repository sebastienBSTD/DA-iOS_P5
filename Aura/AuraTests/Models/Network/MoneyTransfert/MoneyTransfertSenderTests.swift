//
//  MoneyTransfertSenderTests.swift
//  AuraTests
//
//  Created by Sebastien Bastide on 18/04/2024.
//

import XCTest
@testable import Aura

final class MoneyTransfertSenderTests: XCTestCase {

    func test_init_doesNotMoneyTransfertRequestUponCreation() {
        let result: Result<(Data, HTTPURLResponse), Error> = .failure(anyNSError())
        let (_, client) = makeSUT(result: result)

        XCTAssertEqual(client.requests, [])
    }

    func test_loadDetails_deliversErrorOnClientFailed() async {
        let expectedError = anyNSError()
        let result: Result<(Data, HTTPURLResponse), Error> = .failure(expectedError)
        let (sut, _) = makeSUT(result: result)

        do {
            try await sut.sendMoney(from: anyURLRequest())
            XCTFail("Expected failure")
        } catch {
            XCTAssertEqual(error as NSError, expectedError)
        }
    }

    func test_loadDetails_deliversErrorOnANon200HTTPURLResponseStatusCode() async {
        let result: Result<(Data, HTTPURLResponse), Error> = .success((anyData(), anyHTTPURLResponse(statusCode: 300)))
        let (sut, _) = makeSUT(result: result)

        do {
            try await sut.sendMoney(from: anyURLRequest())
            XCTFail("Expected failure")
        } catch {
            XCTAssertEqual(error as! MoneyTransfertSender.Error, .invalidStatusCodeResponse)
        }
    }

    func test_loadDetails_deliversTransfertMoneyTransactionSucceded() async {
        let result: Result<(Data, HTTPURLResponse), Error> = .success((anyData(), anyHTTPURLResponse()))
        let (sut, _) = makeSUT(result: result)

        do {
            try await sut.sendMoney(from: anyURLRequest())
        } catch {
            XCTFail("Expected success")
        }
    }

    // MARK: - Helpers

    private func makeSUT(result: Result<(Data, HTTPURLResponse), Error>) -> (sut: MoneyTransfertSender, client: HTTPClientStub) {
        let client = HTTPClientStub(result: result)
        let sut = MoneyTransfertSender(client: client)

        return (sut, client)
    }
}
