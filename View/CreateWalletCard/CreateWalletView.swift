import SwiftUI
import SwiftData

struct CreateWalletView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    let user: User
    
    @State private var name: String = ""
    @State private var startingBalance: Decimal = 0
    
    private var canSave: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private func save() {
        // 1. Создаём кошелёк с балансом 0
        let wallet = Wallet(name: name, balance: 0, user: user)
        context.insert(wallet)
        
        // 2. Если введён стартовый баланс → пишем транзакцию в категорию "Salary"
        if startingBalance > 0 {
            // ищем категорию "Salary" у пользователя
            let salaryCategory = (try? context.fetch(FetchDescriptor<Category>()))?
                .first(where: { $0.user == user && $0.name == "Salary" && $0.isIncome })
            
            // если нет — создаём новую
            let category = salaryCategory ?? Category(
                name: "Salary",
                emoji: "💼",
                isIncome: true,
                user: user
            )
            if salaryCategory == nil {
                context.insert(category)
            }
            
            let tx = Transaction(
                amount: startingBalance,
                date: Date(),
                note: "Initial balance",
                isIncome: true,
                category: category,
                wallet: wallet
            )
            context.insert(tx)
        }
        
        try? context.save()
        dismiss()
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    
                    // 🔹 Поля для заполнения
                    VStack(spacing: 16) {
                        TextField("Wallet name", text: $name)
                            .padding()
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                        
                        TextField("Starting balance", value: $startingBalance, format: .number)
                            .keyboardType(.decimalPad)
                            .padding()
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    .padding(.horizontal)
                    
                    // 🔹 Кнопка создать
                    Button(action: save) {
                        Text("Create Wallet")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(canSave ? Color.blue : Color.gray.opacity(0.4))
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    .padding(.horizontal)
                    .disabled(!canSave)
                    
                    Spacer()
                }
                .padding(.top, 20)
            }
            .navigationTitle("New Wallet")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}
