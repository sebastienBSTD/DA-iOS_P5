//
//  AuthEndpoint.swift
//  Aura
//
//  Created by Sebastien Bastide on 17/04/2024.
//

import Foundation

enum AuthEndpoint {

    private struct AuthRequest: Encodable {
        let username: String
        let password: String
    }

    static func request(with username: String, and password: String) throws -> URLRequest {
        let baseURL = URL(string: "http://127.0.0.1:8080/auth")!
        let authRequest = AuthRequest(username: username, password: password)
        let data = try JSONEncoder().encode(authRequest)

        var request = URLRequest(url: baseURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = data

        return request
    }
}
