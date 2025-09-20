import SwiftUI
import SwiftData

struct AddTransactionView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    @Query private var categories: [Category]
    
    @State private var amountText: String = ""
    @State private var selectedCategory: Category?
    @State private var note: String = ""
    
    @State private var showCreateCategory = false
    @State private var newCategoryIsIncome = false
    
    @State private var confirmDeleteCategory: Category?
    
    var wallet: Wallet
    var onCommit: (_ transaction: Transaction) -> Void
    
    private var amountDecimal: Decimal? {
        Decimal(string: amountText.replacingOccurrences(of: ",", with: "."))
    }
    
    private var expenseCategories: [Category] {
        categories.filter { !$0.isIncome && $0.user.id == wallet.user.id }
    }
    
    private var incomeCategories: [Category] {
        categories.filter { $0.isIncome && $0.user.id == wallet.user.id }
    }
    
    // MARK: - Actions
    private func commit() {
        guard let category = selectedCategory,
              let amount = amountDecimal,
              amount > 0 else { return }
        
        let transaction = Transaction(
            amount: amount,
            date: Date(),
            note: note,
            isIncome: category.isIncome,
            category: category,
            wallet: wallet
        )
        onCommit(transaction)
        dismiss()
    }
    
    var body: some View {
        VStack(spacing: 24) {
            
            // 🔹 Ввод суммы
            TextField("0.00", text: $amountText)
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.center)
                .font(.system(size: 42, weight: .bold, design: .rounded))
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding()
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button("Done") { UIApplication.shared.hideKeyboard() }
                    }
                }
            
            // 🔹 Категории (две колонки + кнопка создания)
            HStack(alignment: .top, spacing: 16) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Expenses")
                        .font(.caption).foregroundColor(.secondary)
                    ForEach(expenseCategories) { cat in categoryRow(cat) }
                    Button {
                        newCategoryIsIncome = false
                        showCreateCategory = true
                    } label: {
                        Label("New Expense Category", systemImage: "plus.circle.fill")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                    }
                }
                
                Divider()
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Income")
                        .font(.caption).foregroundColor(.secondary)
                    ForEach(incomeCategories) { cat in categoryRow(cat) }
                    Button {
                        
                        newCategoryIsIncome = true
                        showCreateCategory = true
                    } label: {
                        Label("New Income Category", systemImage: "plus.circle.fill")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                    }
                }
            }
            .padding(.horizontal)
            .frame(maxHeight: 250)
            
            
            // 🔹 Заметка
            TextField("Optional note", text: $note)
                .padding()
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal)
            
            Spacer()
            
            // 🔹 Универсальная кнопка-карточка
            if let category = selectedCategory, let amount = amountDecimal {
                Button(action: commit) {
                    transactionCard(category: category, amount: amount)
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            } else {
                placeholderCard
            }
        }
        .navigationTitle("Add Transaction")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showCreateCategory) {
            NavigationStack {
//                Text("DEBUG create preset: \(newCategoryIsIncome ? "Income" : "Expense")")
                CreateCategoryView(
                    user: wallet.user,
                    isIncome: $newCategoryIsIncome
                ) { newCat in
                    selectedCategory = newCat   // 👈 сразу выбираем созданную
                }
            }
        }
        .alert(item: $confirmDeleteCategory) { cat in
            Alert(
                title: Text("Delete Category"),
                message: Text("Are you sure you want to delete \"\(cat.name)\"? Transactions will keep data, but category will be removed."),
                primaryButton: .destructive(Text("Delete")) {
                    deleteCategory(cat)
                },
                secondaryButton: .cancel()
            )
        }
    }
    
    // MARK: - UI Helpers
    private func categoryRow(_ cat: Category) -> some View {
        HStack(spacing: 8) {
            // 👉 сама "карточка" категории (нажимаем, чтобы выбрать)
            Button {
                selectedCategory = cat
            } label: {
                HStack(spacing: 6) {
                    Text(cat.emoji)
                    Text(cat.name)
                        .font(.subheadline)
                    
                    if selectedCategory?.id == cat.id {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.white)
                            .font(.caption)
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(selectedCategory?.id == cat.id ? Color.blue : Color(.systemGray6))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(selectedCategory?.id == cat.id ? Color.blue : Color.gray.opacity(0.3), lineWidth: 1)
                        )
                )
                .foregroundColor(selectedCategory?.id == cat.id ? .white : .primary)
            }
            .buttonStyle(.plain)
            
            Spacer()
            // 👉 крестик справа
            Button {
                confirmDeleteCategory = cat
            } label: {
                Image(systemName: "xmark")
                    .foregroundColor(.gray.opacity(0.6))
                    
            }
            .buttonStyle(.plain)
        }
    }
    
    private func transactionCard(category: Category, amount: Decimal) -> some View {
        HStack {
            Text(category.emoji).font(.title2)
            VStack(alignment: .leading) {
                Text(category.name)
                    .font(.headline)
                    .foregroundColor(.white)
                Text(note.isEmpty ? "No note" : note)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
            }
            Spacer()
            Text("\(category.isIncome ? "+" : "-")\(amount, format: .currency(code: "CNY"))")
                .font(.headline)
                .foregroundColor(.white)
            Image(systemName: "arrow.right.circle.fill")
                .font(.title2)
                .foregroundColor(.white.opacity(0.9))
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 70)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(category.isIncome ? Color.green : Color.red)
        )
        .shadow(color: .black.opacity(0.2), radius: 6, x: 0, y: 3)
    }
    
    private var placeholderCard: some View {
        HStack {
            Text("Select category and enter amount")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, minHeight: 70)
        .background(RoundedRectangle(cornerRadius: 16).fill(Color(.systemGray5)))
        .padding(.horizontal)
        .padding(.bottom, 20)
    }
    
    private func deleteCategory(_ category: Category) {
        // если категория удаляется и она выбрана в данный момент
        if selectedCategory?.id == category.id {
            selectedCategory = nil
        }
        context.delete(category)
        try? context.save()
    }
}

extension UIApplication {
    func hideKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder),
                   to: nil, from: nil, for: nil)
    }
}
