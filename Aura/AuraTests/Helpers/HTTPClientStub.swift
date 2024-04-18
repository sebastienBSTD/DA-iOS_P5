//
//  HTTPClientStub.swift
//  AuraTests
//
//  Created by Sebastien Bastide on 18/04/2024.
//

import Foundation
@testable import Aura

final class HTTPClientStub: HTTPClient {

    private let result: Result<(Data, HTTPURLResponse), Error>
    private(set) var requests: [URLRequest] = []

    init(result: Result<(Data, HTTPURLResponse), Error>) {
        self.result = result
    }

    func request(from request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        requests.append(request)

        return try result.get()
    }
}
