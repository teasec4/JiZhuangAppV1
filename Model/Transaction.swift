//
//  Transaction.swift
//  JiZhuangAppV1
//
//  Created by Максим Ковалев on 9/13/25.
//
import Foundation
import SwiftData

@Model
final class Transaction {
    @Attribute(.unique) var id: UUID
    var amount: Decimal
    var date: Date
    var note: String?
    var isIncome: Bool
    
    // ✅ теперь категория может быть nil
    @Relationship(deleteRule: .nullify, inverse: \Category.transactions)
    var category: Category?
    var wallet: Wallet
    
    init(amount: Decimal,
         date: Date = .now,
         note: String? = nil,
         isIncome: Bool,
         category: Category,
         wallet: Wallet) {
        self.id = UUID()
        self.amount = amount
        self.date = date
        self.note = note
        self.isIncome = isIncome
        self.category = category
        self.wallet = wallet
    }
}
