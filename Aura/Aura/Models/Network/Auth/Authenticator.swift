//
//  Authenticator.swift
//  Aura
//
//  Created by Sebastien Bastide on 17/04/2024.
//

import Foundation

final class Authenticator {

    private let client: HTTPClient

    init(client: HTTPClient = URLSessionHTTPClient()) {
        self.client = client
    }

    func requestToken(from request: URLRequest) async throws -> String {
        let (data, response) = try await client.request(from: request)
        let token = try AuthMapper.map(data, and: response)

        return token
    }
}
