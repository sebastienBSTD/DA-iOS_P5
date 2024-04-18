//
//  AuthMapperTests.swift
//  AuraTests
//
//  Created by Sebastien Bastide on 18/04/2024.
//

import XCTest
@testable import Aura

final class AuthMapperTests: XCTestCase {

    func test_map_throwsErrorOnANon200HTTPURLResponseStatusCode() throws {
        let wrongStatusCodes = [199, 201, 300, 400, 500]

        try wrongStatusCodes.forEach { code in
            XCTAssertThrowsError(
                try AuthMapper.map(anyData(), and: anyHTTPURLResponse(statusCode: code))
            )
        }
    }

    func test_map_throwsErrorOnInvalidData() {
        XCTAssertThrowsError(
            try AuthMapper.map(anyData(), and: anyHTTPURLResponse())
        )
    }

    func test_map_deliversTokenOnAValidDataAnd200HTTPURLResponseStatusCode() throws {
        let item = makeTokenItem()
        let json = makeItemsJSON(item.json)

        let token = try AuthMapper.map(json, and: anyHTTPURLResponse())

        XCTAssertEqual(token, item.model)
    }
}
