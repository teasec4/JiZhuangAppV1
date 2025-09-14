import SwiftUI
import SwiftData

struct RegisterView: View {
    @Environment(\.modelContext) private var context
    
    @State private var step = 1
    @State private var name: String = ""
    @State private var walletName: String = ""
    @State private var walletBalance: String = ""
    
    var onComplete: () -> Void
    
    private func finishRegistration() {
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty,
              !walletName.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        
        let user = User(name: name)
        context.insert(user)
        
        let balanceDecimal = Decimal(string: walletBalance) ?? 0
        let wallet = Wallet(name: walletName, balance: balanceDecimal, user: user)
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
                        
                        Button("Finish") {
                            finishRegistration()
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .padding(.horizontal, 40)
                        .disabled(walletName.trimmingCharacters(in: .whitespaces).isEmpty)
                    }
                }
                
                Spacer()
            }
        }
    }
}
