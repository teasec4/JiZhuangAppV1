//
//  Wallet.swift
//  JiZhuangAppV1
//
//  Created by Максим Ковалев on 9/13/25.
//
import Foundation
import SwiftData


@Model
final class Wallet {
    @Attribute(.unique) var id: UUID
    var name: String
    
    var user: User
    
    // Relationships
    @Relationship(deleteRule: .cascade, inverse: \Transaction.wallet)
    var transactions: [Transaction] = []
    
    init(name: String, balance: Decimal = 0, user: User) {
        self.id = UUID()
        self.name = name
        self.user = user
    }
    
    var balance: Decimal {
        transactions.reduce(0) { result, tx in
            result + (tx.isIncome ? tx.amount : -tx.amount)
        }
    }
}
