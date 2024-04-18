//
//  MoneyTransfertEndpointTests.swift
//  AuraTests
//
//  Created by Sebastien Bastide on 18/04/2024.
//

import XCTest
@testable import Aura

final class MoneyTransfertEndpointTests: XCTestCase {

    func test_buildsMoneyTransfertRequest() throws {
        let recipient = "a recipient"
        let amount = 0.0
        let token = "a token"
        let sut = try MoneyTransfertEndpoint.request(with: recipient, amount: amount, and: token)

        XCTAssertEqual(sut.url, URL(string: "http://127.0.0.1:8080/account/transfer")!)
        XCTAssertEqual(sut.httpMethod, "POST")
        XCTAssertEqual(sut.allHTTPHeaderFields, ["token": token, "Content-Type": "application/json"])
        XCTAssertNotNil(sut.httpBody)
    }
}
