//
//  AccountDetailViewModel.swift
//  Aura
//
//  Created by Vincent Saluzzo on 29/09/2023.
//

import Foundation

final class AccountDetailViewModel: ObservableObject {

    struct Transaction {
        let description: String
        let amount: String
    }

    @Published var totalAmount: String = "€12,345.67"
    @Published var allTransactions: [Transaction] = [
        Transaction(description: "Starbucks", amount: "-€5.50"),
        Transaction(description: "Amazon Purchase", amount: "-€34.99"),
        Transaction(description: "Salary", amount: "+€2,500.00")
    ]

    private let loader: AccountDetailsLoader
    private let tokenStore: TokenStore

    init(loader: AccountDetailsLoader = AccountDetailsLoader(),
         tokenStore: TokenStore = KeychainStore()) {
        self.loader = loader
        self.tokenStore = tokenStore
    }

    func loadAccountDetails() async {
        do {
            let data = try tokenStore.retrieve()
            let token = String(data: data, encoding: .utf8)!
            let request = AccountDetailsEndpoint.request(token: token)
            let item = try await loader.loadDetails(from: request)
            await updateDetailsOnMainThread(item: item)
        } catch {
            print(error)
        }
    }

    @MainActor
    func updateDetailsOnMainThread(item: AccountDetailsItem) {
        totalAmount = "€\(item.currentBalance)"
        allTransactions = item.transactions.map {
            Transaction(
                description: $0.label,
                amount: $0.value < 0 ? "-€\(abs($0.value))" : "+€\(abs($0.value))"
            )
        }
    }
}
