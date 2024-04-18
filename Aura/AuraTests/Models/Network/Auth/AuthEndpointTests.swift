//
//  AuthEndpointTests.swift
//  AuraTests
//
//  Created by Sebastien Bastide on 18/04/2024.
//

import XCTest
@testable import Aura

final class AuthEndpointTests: XCTestCase {

    func test_buildsTheAuthRequest() throws {
        let username = "a username"
        let password = "a password"
        let sut = try AuthEndpoint.request(with: username, and: password)

        XCTAssertEqual(sut.url, URL(string: "http://127.0.0.1:8080/auth")!)
        XCTAssertEqual(sut.httpMethod, "POST")
        XCTAssertEqual(sut.allHTTPHeaderFields, ["Content-Type": "application/json"])
        XCTAssertNotNil(sut.httpBody)
    }
}
