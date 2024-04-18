//
//  AccountDetailsEndpointTests.swift
//  AuraTests
//
//  Created by Sebastien Bastide on 18/04/2024.
//

import XCTest
@testable import Aura

final class AccountDetailsEndpointTests: XCTestCase {

    func test_buildsTheAccountDetailsRequest() {
        let token = "a token"
        let sut = AccountDetailsEndpoint.request(token: token)

        XCTAssertEqual(sut.url, URL(string: "http://127.0.0.1:8080/account")!)
        XCTAssertEqual(sut.httpMethod, "GET")
        XCTAssertEqual(sut.allHTTPHeaderFields, ["token": token])
        XCTAssertNil(sut.httpBody)
    }
}
