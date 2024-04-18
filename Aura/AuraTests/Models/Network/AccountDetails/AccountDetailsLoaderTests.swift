//
//  AccountDetailsLoaderTests.swift
//  AuraTests
//
//  Created by Sebastien Bastide on 18/04/2024.
//

import XCTest
@testable import Aura

final class AccountDetailsLoaderTests: XCTestCase {

    func test_init_doesNotAccountDetailsRequestUponCreation() {
        let result: Result<(Data, HTTPURLResponse), Error> = .failure(anyNSError())
        let (_, client) = makeSUT(result: result)

        XCTAssertEqual(client.requests, [])
    }

    func test_loadDetails_deliversErrorOnClientFailed() async {
        let expectedError = anyNSError()
        let result: Result<(Data, HTTPURLResponse), Error> = .failure(expectedError)
        let (sut, _) = makeSUT(result: result)

        do {
            _ = try await sut.loadDetails(from: anyURLRequest())
            XCTFail("Expected failure")
        } catch {
            XCTAssertEqual(error as NSError, expectedError)
        }
    }

    func test_loadDetails_deliversErrorOnMapperFailed() async {
        let result: Result<(Data, HTTPURLResponse), Error> = .success((anyData(), anyHTTPURLResponse()))
        let (sut, _) = makeSUT(result: result)

        do {
            _ = try await sut.loadDetails(from: anyURLRequest())
            XCTFail("Expected failure")
        } catch {
            XCTAssertEqual(error as! AccountDetailsMapper.Error, .invalidResponse)
        }
    }

    func test_loadDetails_deliversAccountDetailsOnSucceedRequest() async {
        let item = makeAccountDetailsItem()
        let json = makeItemsJSON(item.json)
        let result: Result<(Data, HTTPURLResponse), Error> = .success((json, anyHTTPURLResponse()))
        let (sut, _) = makeSUT(result: result)

        do {
            let token = try await sut.loadDetails(from: anyURLRequest())
            XCTAssertEqual(token, item.model)
        } catch {
            XCTFail("Expected success")
        }
    }

    // MARK: - Helpers

    private func makeSUT(result: Result<(Data, HTTPURLResponse), Error>) -> (sut: AccountDetailsLoader, client: HTTPClientStub) {
        let client = HTTPClientStub(result: result)
        let sut = AccountDetailsLoader(client: client)

        return (sut, client)
    }
}
