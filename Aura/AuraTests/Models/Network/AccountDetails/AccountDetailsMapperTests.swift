//
//  AccountDetailsMapperTests.swift
//  AuraTests
//
//  Created by Sebastien Bastide on 18/04/2024.
//

import XCTest
@testable import Aura

final class AccountDetailsMapperTests: XCTestCase {

    func test_map_throwsErrorOnANon200HTTPURLResponseStatusCode() throws {
        let wrongStatusCodes = [199, 201, 300, 400, 500]

        try wrongStatusCodes.forEach { code in
            XCTAssertThrowsError(
                try AccountDetailsMapper.map(anyData(), and: anyHTTPURLResponse(statusCode: code))
            )
        }
    }

    func test_map_throwsErrorOnInvalidData() {
        XCTAssertThrowsError(
            try AccountDetailsMapper.map(anyData(), and: anyHTTPURLResponse())
        )
    }

    func test_map_deliversTokenOnAValidDataAnd200HTTPURLResponseStatusCode() throws {
        let item = makeAccountDetailsItem()
        let json = makeItemsJSON(item.json)

        let accountDetailsItem = try AccountDetailsMapper.map(json, and: anyHTTPURLResponse())

        XCTAssertEqual(accountDetailsItem, item.model)
    }
}
