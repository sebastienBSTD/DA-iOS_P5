//
//  AccountDetailsLoader.swift
//  Aura
//
//  Created by Sebastien Bastide on 17/04/2024.
//

import Foundation

final class AccountDetailsLoader {

    private let client: HTTPClient

    init(client: HTTPClient = URLSessionHTTPClient()) {
        self.client = client
    }

    func loadDetails(from request: URLRequest) async throws -> AccountDetailsItem {
        let (data, response) = try await client.request(from: request)
        let item = try AccountDetailsMapper.map(data, and: response)

        return item
    }
}
