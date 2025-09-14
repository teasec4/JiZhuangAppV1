import SwiftUI
import SwiftData

struct EditTransactionView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    @Query private var categories: [Category]
    
    @State private var amountText: String = ""
    @State private var selectedCategory: Category?
    @State private var note: String = ""
    @State private var isIncome: Bool = false
    
    var transaction: Transaction
    
    private func cancel() {
        dismiss()
    }
    
    private func saveChanges() {
        if let amount = Decimal(string: amountText), amount > 0 {
            transaction.amount = amount
            transaction.note = note
            transaction.isIncome = isIncome
            if let category = selectedCategory {
                transaction.category = category
            }
            try? context.save()
            dismiss()
        }
    }
    
    private var canSave: Bool {
        (Decimal(string: amountText).map { $0 > 0 } ?? false) && selectedCategory != nil
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    
                    // 🔹 Переключатель доход/расход
                    HStack(spacing: 12) {
                        transactionTypeButton("Expense", active: !isIncome, color: .red) {
                            isIncome = false
                        }
                        transactionTypeButton("Income", active: isIncome, color: .green) {
                            isIncome = true
                        }
                    }
                    
                    // 🔹 Сумма
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Amount")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        TextField("0.00", text: $amountText)
                            .keyboardType(.decimalPad)
                            .font(.system(size: 32, weight: .semibold, design: .rounded))
                            .foregroundColor(isIncome ? .green : .red)
                            .padding()
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    
                    // 🔹 Категория
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Category")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        NavigationLink {
                            CategoryPickerView(isIncome: isIncome, user: transaction.wallet.user, selectedCategory: $selectedCategory)
                        } label: {
                            HStack {
                                if let category = selectedCategory {
                                    Text("\(category.emoji) \(category.name)")
                                        .font(.headline)
                                } else {
                                    Text("Choose category")
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.secondary)
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                        }
                    }
                    
                    // 🔹 Заметка
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Note")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        TextField("Optional note", text: $note)
                            .padding()
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    
                    Spacer()
                }
                .padding()
            }
            .background((isIncome ? Color.green.opacity(0.05) : Color.red.opacity(0.05)))
            .ignoresSafeArea(edges: .bottom)
            .navigationTitle("Edit Transaction")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", action: cancel)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save", action: saveChanges)
                        .disabled(!canSave)
                }
            }
            .onAppear {
                amountText = "\(transaction.amount)"
                selectedCategory = transaction.category
                note = transaction.note ?? ""
                isIncome = transaction.isIncome
            }
        }
    }
    
    // 🔹 Универсальная кнопка переключателя
    private func transactionTypeButton(_ title: String, active: Bool, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(active ? color.opacity(0.2) : Color(.systemGray6))
                .foregroundColor(active ? color : .primary)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}
