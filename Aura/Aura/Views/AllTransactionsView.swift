//
//  AllTransactionsView.swift
//  Aura
//
//  Created by Sebastien Bastide on 17/04/2024.
//

import SwiftUI

struct AllTransactionsView: View {

    let transactions: [AccountDetailViewModel.Transaction]

    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                Text("All Transactions")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical)
                ForEach(transactions, id: \.description) { transaction in
                    HStack {
                        Image(systemName: transaction.amount.contains("+") ? "arrow.up.right.circle.fill" : "arrow.down.left.circle.fill")
                            .foregroundColor(transaction.amount.contains("+") ? .green : .red)
                        Text(transaction.description)
                        Spacer()
                        Text(transaction.amount)
                            .fontWeight(.bold)
                            .foregroundColor(transaction.amount.contains("+") ? .green : .red)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    .padding([.horizontal])
                }
            }
        }
    }
}

#Preview {
    AllTransactionsView(transactions: [
        AccountDetailViewModel.Transaction(description: "Starbucks", amount: "-€5.50"),
        AccountDetailViewModel.Transaction(description: "Amazon Purchase", amount: "-€34.99"),
        AccountDetailViewModel.Transaction(description: "Salary", amount: "+€2,500.00")
    ])
}
