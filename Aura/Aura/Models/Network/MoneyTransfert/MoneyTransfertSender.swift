//
//  MoneyTransfertSender.swift
//  Aura
//
//  Created by Sebastien Bastide on 17/04/2024.
//

import Foundation

final class MoneyTransfertSender {

    private let client: HTTPClient

    init(client: HTTPClient = URLSessionHTTPClient()) {
        self.client = client
    }

    private enum Error: Swift.Error {
        case invalidStatusCodeResponse
    }

    func sendMoney(from request: URLRequest) async throws {
        let (_, response) = try await client.request(from: request)
        guard response.statusCode == 200 else {
            throw Error.invalidStatusCodeResponse
        }
    }
}
