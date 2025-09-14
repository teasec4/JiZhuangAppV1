//
//  AddTransactionView.swift
//  JiZhuangAppV1
//
//  Created by Максим Ковалев on 9/13/25.
//

import SwiftUI
import SwiftData

struct AddTransactionView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    @Query private var wallets: [Wallet]
    @Query private var categories: [Category]
    
    @State private var amountText: String = ""
    @State private var amount: Decimal = 0
    @State private var selectedCategory: Category?
    @State private var selectedWallet: Wallet?
    @State private var note: String = ""
    
    @State private var isIncome: Bool = false
    
    
    private func cancel(){
        dismiss()
    }
    
    var wallet: Wallet
    
    var onCommit: (_ transaction:Transaction) -> Void
    
    private func commit() {
        guard let category = selectedCategory, let wallet = selectedWallet, let amount = Decimal(string: amountText), amount > 0 else { return }
        
        let transaction = Transaction(
            amount: amount,
            date: Date(),
            note: note,
            isIncome: isIncome,
            category: category,
            wallet: wallet
        )
        
        onCommit(transaction)
        dismiss()
    }
    var body: some View {
        NavigationStack{
            ZStack{
                (isIncome ? Color.green.opacity(0.05) : Color.red.opacity(0.05))
                    .ignoresSafeArea()
                VStack{
                    HStack(spacing: 12) {
                        Button {
                            isIncome = false
                        } label: {
                            Text("Expense")
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(!isIncome ? Color.red.opacity(0.2) : Color.gray.opacity(0.2))
                                .foregroundColor(!isIncome ? .red : .primary)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        
                        Button {
                            isIncome = true
                        } label: {
                            Text("Income")
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(isIncome ? Color.green.opacity(0.2) : Color.gray.opacity(0.2))
                                .foregroundColor(isIncome ? .green : .primary)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }
                    .padding(.horizontal)
                    
                    Form{
                    
                        Section("Amount") {
                            TextField("Enter amount", text: $amountText)
                                .keyboardType(.decimalPad)
                                .foregroundColor(isIncome ? .green : .red)
                        }
                        
                        Section("Category") {
                            NavigationLink {
                                CategoryPickerView(isIncome: isIncome,
                                                   selectedCategory: $selectedCategory)
                            } label: {
                                HStack {
                                    if let category = selectedCategory {
                                        Text("\(category.emoji) \(category.name)")
                                    } else {
                                        Text("Choose category")
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }
                        }
                        
                        Section("Note") {
                            TextField("Optional note", text: $note)
                        }
                    }
                }
            }
            .navigationTitle("Add transaction")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .cancellationAction){
                    Button(action: cancel){
                        Text("Cancel")
                    }
                }
                ToolbarItem(placement: .confirmationAction){
                    Button(action: commit){
                        Text("Add")
                    }
                    .disabled(selectedCategory == nil || selectedWallet == nil)
                }
            }
            .onAppear {
                // Автовыбор первого кошелька/категории для удобства
                if selectedWallet == nil { selectedWallet = wallets.first }
                if selectedCategory == nil {
                        // пример: берём первую категорию дохода/расхода
                        // (тут нужен @Query для категорий)
                    }
            }
        }
    }
}


