//
//  Wallet.swift
//  JiZhuangAppV1
//
//  Created by Максим Ковалев on 9/13/25.
//
import Foundation
import SwiftData


@Model
final class Wallet:Identifiable {
    @Attribute(.unique) var id: UUID
    var name: String
    var colorHex: String
    
    // Relationships
    @Relationship(deleteRule: .cascade, inverse: \Transaction.wallet)
    var transactions: [Transaction] = []
    
    @Relationship(deleteRule: .nullify, inverse: \Category.user)
        var user: User
    
    init(name: String, balance: Decimal = 0, user: User, colorHex: String = "#2196F3") {
        self.id = UUID()
        self.name = name
        self.user = user
        self.colorHex = colorHex
    }
    
    var balance: Decimal {
        transactions.reduce(0) { result, tx in
            result + (tx.isIncome ? tx.amount : -tx.amount)
        }
    }
}
