import SwiftUI
import SwiftData

struct CreateWalletView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    var user: User
    
    @State private var name: String = ""
    @State private var selectedColor: String = "#2196F3"
    @State private var startBalance: String = ""
    
    let colors: [String] = [
        "#2196F3", "#4CAF50", "#FF9800", "#9C27B0", "#F44336"
    ]
    
    var body: some View {
        VStack {
            Form {
                Section("Wallet Info") {
                    TextField("Wallet name", text: $name)
                    TextField("Start balance", text: $startBalance)
                        .keyboardType(.decimalPad)
                }
                
                Section("Card Color") {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(colors, id: \.self) { hex in
                                Circle()
                                    .fill(Color(hex: hex))
                                    .frame(width: 40, height: 40)
                                    .overlay(
                                        Circle().stroke(selectedColor == hex ? Color.primary : .clear, lineWidth: 2)
                                    )
                                    .onTapGesture {
                                        selectedColor = hex
                                    }
                            }
                        }
                        .padding(.vertical, 6)
                    }
                }
            }
            .scrollContentBackground(.hidden)
            
            // 🔽 Превью-кнопка
            Button(action: saveWallet) {
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(name.isEmpty ? "New Wallet" : name)
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        let balanceDecimal = Decimal(string: startBalance.replacingOccurrences(of: ",", with: ".")) ?? 0
                        Text("\(balanceDecimal, format: .currency(code: "CNY"))")
                            .font(.subheadline.bold())
                            .foregroundColor(.white.opacity(0.9))
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 4) {
                        Text("Create")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                        Image(systemName: "arrow.right.circle.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, minHeight: 80)
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(Color(hex: selectedColor))
                        .shadow(color: .black.opacity(0.2), radius: 6, x: 0, y: 3)
                )
                .padding(.horizontal)
            }
            .disabled(name.isEmpty)
            .opacity(name.isEmpty ? 0.5 : 1)
            .padding(.vertical, 12)
        }
        .navigationTitle("Create Wallet")
    }
    
    // MARK: - Save Logic
    private func saveWallet() {
        let wallet = Wallet(name: name, user: user, colorHex: selectedColor)
        context.insert(wallet)
        
        if let amount = Decimal(string: startBalance.replacingOccurrences(of: ",", with: ".")),
           amount > 0 {
            
            let fetch = FetchDescriptor<Category>()
            if let salaryCategory = try? context.fetch(fetch).first(where: { $0.name == "Salary" && $0.user.id == user.id }) {
                let tx = Transaction(amount: amount,
                                     note: "Initial balance",
                                     isIncome: true,
                                     category: salaryCategory,
                                     wallet: wallet)
                context.insert(tx)
            } else {
                let salaryCategory = Category(name: "Salary", emoji: "💼", isIncome: true, user: user)
                context.insert(salaryCategory)
                let tx = Transaction(amount: amount,
                                     note: "Initial balance",
                                     isIncome: true,
                                     category: salaryCategory,
                                     wallet: wallet)
                context.insert(tx)
            }
        }
        
        try? context.save()
        dismiss()
    }
}
