//
//  TransactionViewModel.swift
//  JiZhuangAppV1
//
//  Created by Максим Ковалев on 9/13/25.
//

import Foundation
import SwiftData
import Combine

@MainActor
final class TransactionViewModel: ObservableObject {
    private var context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    
    func addTransaction(amount: Decimal,
                        note: String?,
                        isIncome: Bool,
                        category: Category,
                        wallet: Wallet) {
        let tx = Transaction(amount: amount,
                             note: note,
                             isIncome: isIncome,
                             category: category,
                             wallet: wallet)
        context.insert(tx)
        save()
    }
    
    func deleteTransaction(_ tx: Transaction) {
        context.delete(tx)
        save()
    }
    
    private func save() {
        do {
            try context.save()
        } catch {
            print("❌ Error saving context: \(error)")
        }
    }
}
