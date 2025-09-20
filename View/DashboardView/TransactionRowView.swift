import SwiftUI

struct TransactionRowView: View {
    var transaction: Transaction
    
    var body: some View {
        HStack(spacing: 14) {
            // 🔹 Иконка категории
            Text(transaction.category?.emoji  ?? "❓")
                .font(.title2)
                .frame(width: 44, height: 44)
                .background(
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: transaction.isIncome ? [.green, .mint] : [.red, .pink],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(transaction.category?.name ?? "Unknown Category")
                    .font(.headline)
                    .foregroundColor(.primary)
                
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
            
            Text("\(transaction.isIncome ? "+" : "-")\(transaction.amount, format: .number) ￥")
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundColor(transaction.isIncome ? .green : .red)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(.systemGray6))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.gray.opacity(0.15), lineWidth: 0.8)
                )
                .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 3)
        )
    }
}
