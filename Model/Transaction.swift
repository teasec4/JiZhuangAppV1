//
//  Transaction.swift
//  JiZhuangAppV1
//
//  Created by Максим Ковалев on 9/13/25.
//
import Foundation
import SwiftData

@Model
final class Transaction{
    @Attribute(.unique) var id: UUID
    var amount: Decimal
    var date: Date
    var note: String?
    var isIncome: Bool
    
    // Relationships
    var category: Category
    var wallet: Wallet
    
    init(amount: Decimal,
         date: Date = Date(),
         note: String? = nil,
         isIncome: Bool = false,
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
