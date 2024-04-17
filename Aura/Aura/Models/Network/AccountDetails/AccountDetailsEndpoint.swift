//
//  AccountDetailsEndpoint.swift
//  Aura
//
//  Created by Sebastien Bastide on 17/04/2024.
//

import Foundation

enum AccountDetailsEndpoint {

    static func request(token: String) -> URLRequest {
        let baseURL = URL(string: "http://127.0.0.1:8080/account")!

        var request = URLRequest(url: baseURL)
        request.httpMethod = "GET"
        request.addValue(token, forHTTPHeaderField: "token")

        return request
    }
}
