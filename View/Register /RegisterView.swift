import SwiftUI
import SwiftData

struct RegisterView: View {
    @Environment(\.modelContext) private var context
    
    @State private var step = 1
    @State private var name: String = ""
    @State private var walletName: String = ""
    @State private var walletBalance: String = ""
    @State private var selectedColor: String = "#2196F3" // 🔹 дефолтный цвет
    
    var onComplete: () -> Void
    
    private let colors: [String] = [
        "#2196F3", "#4CAF50", "#FF9800", "#9C27B0", "#F44336"
    ]
    
    private func finishRegistration() {
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty,
              !walletName.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        
        let user = User(name: name)
        context.insert(user)
        
        let balanceDecimal = Decimal(string: walletBalance) ?? 0
        let wallet = Wallet(name: walletName,
                            balance: balanceDecimal,
                            user: user,
                            colorHex: selectedColor) // ✅ сохраняем цвет
        context.insert(wallet)
        
        // дефолтные категории
        let salaryCategory = Category(name: "Salary", emoji: "💼", isIncome: true, user: user)
        let giftCategory = Category(name: "Gift", emoji: "🎁", isIncome: true, user: user)
        let foodCategory = Category(name: "Food", emoji: "🍔", isIncome: false, user: user)
        let transportCategory = Category(name: "Transport", emoji: "🚌", isIncome: false, user: user)
        let shoppingCategory = Category(name: "Shopping", emoji: "🛍️", isIncome: false, user: user)
        [salaryCategory, giftCategory, foodCategory, transportCategory, shoppingCategory].forEach { context.insert($0) }
        
        if balanceDecimal > 0 {
            let tx = Transaction(amount: balanceDecimal, date: Date(),
                                 note: "Initial balance",
                                 isIncome: true,
                                 category: salaryCategory,
                                 wallet: wallet)
            context.insert(tx)
        }
        
        try? context.save()
        onComplete()
    }
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.blue.opacity(0.2), .purple.opacity(0.2)],
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                
                // 🔹 индикатор прогресса
                HStack {
                    Capsule()
                        .fill(step >= 1 ? Color.blue : Color.gray.opacity(0.3))
                        .frame(height: 6)
                    Capsule()
                        .fill(step >= 2 ? Color.blue : Color.gray.opacity(0.3))
                        .frame(height: 6)
                }
                .padding(.horizontal, 60)
                .animation(.easeInOut, value: step)
                
                Spacer()
                
                if step == 1 {
                    VStack(spacing: 20) {
                        Text("Welcome 👋")
                            .font(.largeTitle.bold())
                        
                        Text("What’s your name?")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        TextField("Enter your name", text: $name)
                            .padding()
                            .background(.white)
                            .cornerRadius(12)
                            .padding(.horizontal, 40)
                            .shadow(radius: 2)
                        
                        Button("Next") {
                            withAnimation { step = 2 }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .padding(.horizontal, 40)
                        .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                    }
                } else if step == 2 {
                    VStack(spacing: 20) {
                        Text("Create your first wallet 💰")
                            .font(.title2.bold())
                        
                        Text("You can add balance now or later")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        TextField("Wallet name", text: $walletName)
                            .padding()
                            .background(.white)
                            .cornerRadius(12)
                            .padding(.horizontal, 40)
                            .shadow(radius: 2)
                        
                        TextField("Initial balance (optional)", text: $walletBalance)
                            .keyboardType(.decimalPad)
                            .padding()
                            .background(.white)
                            .cornerRadius(12)
                            .padding(.horizontal, 40)
                            .shadow(radius: 2)
                        
                        // 🎨 выбор цвета
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(colors, id: \.self) { hex in
                                    Circle()
                                        .fill(Color(hex: hex))
                                        .frame(width: 44, height: 44)
                                        .overlay(
                                            Circle()
                                                .stroke(selectedColor == hex ? Color.black : .clear, lineWidth: 2)
                                        )
                                        .onTapGesture {
                                            selectedColor = hex
                                        }
                                }
                            }
                            .padding(.horizontal, 40)
                        }
                        
                        // 🖼 превью кошелька
                        WalletPreviewView(
                            name: walletName.isEmpty ? "My Wallet" : walletName,
                            balance: Decimal(string: walletBalance) ?? 0,
                            colorHex: selectedColor
                        )
                        .padding(.horizontal, 40)
                        .padding(.top, 10)
                        
                        // ✅ кнопка в цвет кошелька
                        Button("Finish") {
                            finishRegistration()
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(hex: selectedColor))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .padding(.horizontal, 40)
                        .disabled(walletName.trimmingCharacters(in: .whitespaces).isEmpty)
                        .animation(.easeInOut, value: selectedColor)
                    }
                }
                
                Spacer()
            }
        }
    }
}

// 🔹 Мини-превью кошелька
struct WalletPreviewView: View {
    var name: String
    var balance: Decimal
    var colorHex: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text(name)
                    .font(.headline)
                    .foregroundColor(.white)
                Text("\(balance, format: .number) CNY")
                    .font(.subheadline.bold())
                    .foregroundColor(.white.opacity(0.9))
            }
            Spacer()
            Image(systemName: "creditcard.fill")
                .foregroundColor(.white.opacity(0.8))
        }
        .padding()
        .frame(height: 80)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(hex: colorHex))
                .shadow(color: .black.opacity(0.2), radius: 6, x: 0, y: 3)
        )
    }
}
