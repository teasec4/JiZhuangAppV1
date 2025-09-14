import SwiftUI
import SwiftData

struct AddTransactionView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    @Query private var categories: [Category]
    
    @State private var amountText: String = ""
    @State private var selectedCategory: Category?
    @State private var note: String = ""
    @State private var isIncome: Bool = false
    
    var wallet: Wallet
    var onCommit: (_ transaction: Transaction) -> Void
    
    // Проверка готовности
    private var canSubmit: Bool {
        (Decimal(string: amountText).map { $0 > 0 } ?? false) && selectedCategory != nil
    }
    
    private func cancel() {
        dismiss()
    }
    
    private func commit() {
        guard let category = selectedCategory,
              let amount = Decimal(string: amountText),
              amount > 0
        else { return }
        
        let transaction = Transaction(
            amount: amount,
            date: Date(),
            note: note,
            isIncome: isIncome,
            category: category,
            wallet: wallet     // 💡 всегда используем переданный кошелёк
        )
        
        onCommit(transaction)
        dismiss()
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
                            CategoryPickerView(isIncome: isIncome, user: wallet.user, selectedCategory: $selectedCategory)
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
            .navigationTitle("Add Transaction")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", action: cancel)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add", action: commit)
                        .disabled(!canSubmit)
                }
            }
            .onAppear {
                if selectedCategory == nil {
                    selectedCategory = categories.first(where: { $0.isIncome == isIncome }) ?? categories.first
                }
            }
        }
    }
    
    // Вынес кнопки Expense/Income
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
