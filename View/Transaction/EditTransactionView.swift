import SwiftUI
import SwiftData

struct EditTransactionView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    @Query private var categories: [Category]
    
    @State private var amountText: String = ""
    @State private var selectedCategory: Category?
    @State private var note: String = ""
    
    @State private var showCreateCategory = false
    @State private var newCategoryIsIncome = false
    
    var transaction: Transaction
    
    private var amountDecimal: Decimal? {
        Decimal(string: amountText.replacingOccurrences(of: ",", with: "."))
    }
    
    private var expenseCategories: [Category] {
        categories.filter { !$0.isIncome && $0.user.id == transaction.wallet.user.id }
    }
    
    private var incomeCategories: [Category] {
        categories.filter { $0.isIncome && $0.user.id == transaction.wallet.user.id }
    }
    
    // MARK: - Actions
    private func saveChanges() {
        guard let category = selectedCategory,
              let amount = amountDecimal,
              amount > 0 else { return }
        
        transaction.amount = amount
        transaction.note = note
        transaction.isIncome = category.isIncome
        transaction.category = category
        
        try? context.save()
        dismiss()
    }
    
    private var canSave: Bool {
        (amountDecimal ?? 0) > 0 && selectedCategory != nil
    }
    
    var body: some View {
        VStack(spacing: 24) {
            
            // 🔹 Ввод суммы
            TextField("0.00", text: $amountText)
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.center)
                .font(.system(size: 42, weight: .bold, design: .rounded))
                .padding(.vertical, 16)
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal, 40)
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button("Done") { UIApplication.shared.hideKeyboard() }
                    }
                }
            
            // 🔹 Категории
            HStack(alignment: .top, spacing: 16) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Expenses")
                        .font(.caption).foregroundColor(.secondary)
                    ForEach(expenseCategories) { cat in categoryRow(cat) }
                    Button {
                        showCreateCategory = true
                        newCategoryIsIncome = false
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
                        showCreateCategory = true
                        newCategoryIsIncome = true
                    } label: {
                        Label("New Income Category", systemImage: "plus.circle.fill")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                    }
                }
            }
            .padding(.horizontal)
            .frame(maxHeight: 250)
            
            Spacer()
            
            // 🔹 Заметка
            TextField("Optional note", text: $note)
                .padding()
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal)
            
            Spacer()
            
            // 🔹 Кнопка-карточка
            if let category = selectedCategory, let amount = amountDecimal {
                Button(action: saveChanges) {
                    transactionCard(category: category, amount: amount)
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
                .disabled(!canSave)
            } else {
                placeholderCard
            }
        }
        .navigationTitle("Edit Transaction")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            amountText = "\(transaction.amount)"
            selectedCategory = transaction.category
            note = transaction.note ?? ""
        }
        .sheet(isPresented: $showCreateCategory) {
            NavigationStack {
                CreateCategoryView(
                    user: transaction.wallet.user,
                    isIncome: $newCategoryIsIncome
                ) { newCat in
                    selectedCategory = newCat   // 👈 сразу выбираем созданную
                }
            }
        }
    }
    
    // MARK: - UI Helpers
    private func categoryRow(_ cat: Category) -> some View {
        Button { selectedCategory = cat } label: {
            HStack {
                Text(cat.emoji)
                Text(cat.name).font(.headline)
                Spacer()
                if selectedCategory?.id == cat.id {
                    Image(systemName: "checkmark.circle.fill").foregroundColor(.blue)
                }
            }
            .padding(.vertical, 6)
        }
        .buttonStyle(.plain)
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
}
