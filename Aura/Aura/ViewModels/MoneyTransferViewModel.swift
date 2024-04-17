//
//  MoneyTransferViewModel.swift
//  Aura
//
//  Created by Vincent Saluzzo on 29/09/2023.
//

import Foundation

final class MoneyTransferViewModel: ObservableObject {

    @Published var recipient: String = ""
    @Published var amount: String = ""
    @Published var transferMessage: String = ""

    private let sender: MoneyTransfertSender
    private let tokenStore: TokenStore

    init(sender: MoneyTransfertSender = MoneyTransfertSender(),
         tokenStore: TokenStore = KeychainStore()) {
        self.sender = sender
        self.tokenStore = tokenStore
    }

    @MainActor
    func sendMoney() async {
        if !recipient.isEmpty && !amount.isEmpty, let decimal = Double(amount), (recipient.isEmail() || recipient.isPhoneNumber()) {
            do {
                let data = try tokenStore.retrieve()
                let token = String(data: data, encoding: .utf8)!
                let request = try MoneyTransfertEndpoint.request(with: recipient, amount: decimal, and: token)
                try await sender.sendMoney(from: request)
                transferMessage = "Successfully transferred \(amount) to \(recipient)"
            } catch {
                transferMessage = "Transfert failed"
            }
        } else {
            transferMessage = "Please enter a correct recipient and amount."
        }
    }
}
