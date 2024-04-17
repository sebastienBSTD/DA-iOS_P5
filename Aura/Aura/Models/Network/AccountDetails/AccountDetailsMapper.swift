//
//  AccountDetailsMapper.swift
//  Aura
//
//  Created by Sebastien Bastide on 17/04/2024.
//

import Foundation

final class AccountDetailsMapper {

    private init() {}

    private struct Root: Decodable {
        let currentBalance: Double
        let transactions: [Transaction]

        struct Transaction: Decodable {
            let value: Double
            let label: String
        }

        var item: AccountDetailsItem {
            AccountDetailsItem(
                currentBalance: currentBalance,
                transactions: transactions.map {
                    TransactionItem(value: $0.value, label: $0.label)
                }
            )
        }
    }

    private enum Error: Swift.Error {
        case invalidResponse
    }

    static func map(_ data: Data, and response: HTTPURLResponse) throws -> AccountDetailsItem {
        guard response.statusCode == 200, let root = try? JSONDecoder().decode(Root.self, from: data) else {
            throw Error.invalidResponse
        }

        return root.item
    }
}
