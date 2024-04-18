//
//  MoneyTransfertEndpoint.swift
//  Aura
//
//  Created by Sebastien Bastide on 17/04/2024.
//

import Foundation

enum MoneyTransfertEndpoint {

    private struct MoneyTransfertRequest: Encodable {
        let recipient: String
        let amount: Double
    }

    static func request(with recipient: String, amount: Double, and token: String) throws -> URLRequest {
        let baseURL = URL(string: "http://127.0.0.1:8080/account/transfer")!
        let moneyTransfertRequest = MoneyTransfertRequest(recipient: recipient, amount: amount)
        let data = try JSONEncoder().encode(moneyTransfertRequest)

        var request = URLRequest(url: baseURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(token, forHTTPHeaderField: "token")
        request.httpBody = data

        return request
    }
}
