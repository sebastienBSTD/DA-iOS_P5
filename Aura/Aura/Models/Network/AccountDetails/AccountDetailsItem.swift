//
//  AccountDetailsItem.swift
//  Aura
//
//  Created by Sebastien Bastide on 17/04/2024.
//

import Foundation

struct AccountDetailsItem: Equatable {
    let currentBalance: Double
    let transactions: [TransactionItem]
}

struct TransactionItem: Equatable {
    let value: Double
    let label: String
}
