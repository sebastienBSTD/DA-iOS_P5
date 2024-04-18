//
//  SharedTestsHelpers.swift
//  AuraTests
//
//  Created by Sebastien Bastide on 18/04/2024.
//

import Foundation
@testable import Aura

func anyURL() -> URL {
    URL(string: "https://www.a-url.com")!
}

func anyURLRequest() -> URLRequest {
    URLRequest(url: anyURL())
}

func anyData() -> Data {
    "a data".data(using: .utf8)!
}

func anyNSError() -> NSError {
    NSError(domain: "a domain", code: 0)
}

func makeTokenItem() -> (model: String, json: [String: String]) {
    let model = "a token"

    let json = [
        "token": model
    ]

    return (model, json)
}

func makeAccountDetailsItem() -> (model: AccountDetailsItem, json: [String: Any]) {
    let model = AccountDetailsItem(
        currentBalance: 0.0,
        transactions: [
            .init(value: 1, label: "a label"),
            .init(value: -1, label: "another label")
        ]
    )

    let json: [String: Any] = [
        "currentBalance": model.currentBalance,
        "transactions": [
            [
                "value": model.transactions[0].value,
                "label": model.transactions[0].label
            ],
            [
                "value": model.transactions[1].value,
                "label": model.transactions[1].label
            ]
        ]
    ]

    return (model, json)
}

func makeItemsJSON(_ item: [String: Any]) -> Data {
    try! JSONSerialization.data(withJSONObject: item)
}

func anyHTTPURLResponse(statusCode: Int = 200) -> HTTPURLResponse {
    HTTPURLResponse(url: anyURL(), statusCode: statusCode, httpVersion: nil, headerFields: nil)!
}
