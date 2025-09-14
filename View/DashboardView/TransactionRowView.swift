//
//  TransactionListView.swift
//  JiZhuangAppV1
//
//  Created by Максим Ковалев on 9/13/25.
//

import SwiftUI

struct TransactionRowView: View {
    var transaction: Transaction
    
    var body: some View {
        HStack(spacing: 12) {
            // 🔹 Иконка категории
            Text(transaction.category.emoji)
                .font(.title2)
                .frame(width: 44, height: 44)
                .background(
                    Circle()
                        .fill(transaction.isIncome ? Color.green.opacity(0.15) : Color.red.opacity(0.15))
                )
                .overlay(
                    Circle()
                        .stroke(transaction.isIncome ? Color.green.opacity(0.4) : Color.red.opacity(0.4), lineWidth: 1)
                )
            
            // 🔹 Основной текст
            VStack(alignment: .leading, spacing: 4) {
                Text(transaction.category.name)
                    .font(.headline)
                
                if let note = transaction.note, !note.isEmpty {
                    Text(note)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
                
                Text(transaction.date, format: Date.FormatStyle().day().month().year().hour().minute())
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // 🔹 Сумма
            Text("\(transaction.isIncome ? "+" : "-")\(transaction.amount, format: .number) ￥")
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundColor(transaction.isIncome ? .green : .red)
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 8)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)
        )
    }
}


