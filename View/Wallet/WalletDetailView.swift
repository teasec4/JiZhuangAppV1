import SwiftUI
import SwiftData

struct WalletDetailView: View {
    @Bindable var wallet: Wallet
    @Environment(\.modelContext) private var context
    
    @State private var showAddTransaction = false
    @State private var selectedTransaction: Transaction?
    
    // 📅 форматируем дату в "09.2025"
    private let monthFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "MM.yyyy"
        return f
    }()
    
    private var groupedTransactions: [(key: String, value: [Transaction])] {
        let dict = Dictionary(grouping: wallet.transactions) { tx in
            monthFormatter.string(from: tx.date)
        }
        return dict
            .map { (key: $0.key, value: $0.value) }
            .sorted { lhs, rhs in
                if let l = lhs.value.first?.date, let r = rhs.value.first?.date {
                    return l > r
                }
                return lhs.key > rhs.key
            }
    }
    
    var body: some View {
        VStack {
            BalanceCardView(
                walletName: wallet.name,
                balance: wallet.balance,
                currency: "￥",
                colorHex: wallet.colorHex
            )
            .padding(.horizontal)
            
            if wallet.transactions.isEmpty {
                // 🔹 Заглушка при отсутствии транзакций
                VStack(spacing: 12) {
                    Image(systemName: "tray")
                        .font(.system(size: 40))
                        .foregroundColor(.secondary)
                    Text("No transactions yet")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    Text("Create your first transaction")
                        .font(.subheadline)
                        .foregroundColor(.secondary.opacity(0.7))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
            } else {
                // 🔹 Секции по месяцам
                List {
                    ForEach(groupedTransactions, id: \.key) { month, txs in
                        Section {
                            ForEach(txs.sorted(by: { $0.date > $1.date })) { tx in
                                TransactionRowView(transaction: tx)
                                    .swipeActions(edge: .trailing) {
                                        Button(role: .destructive) {
                                            context.delete(tx)
                                            try? context.save()
                                        } label: {
                                            Label("Delete", systemImage: "trash")
                                        }
                                        
                                        Button {
                                            selectedTransaction = tx
                                        } label: {
                                            Label("Edit", systemImage: "pencil")
                                        }
                                        .tint(.yellow)
                                    }
                            }
                        } header: {
                            HStack {
                                Text(month)
                                    .font(.headline)
                                Spacer()
                            }
                        }
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            }
        }
        .navigationTitle(wallet.name)
        .navigationBarTitleDisplayMode(.inline)
        
        // 🔹 Добавить транзакцию
        .sheet(isPresented: $showAddTransaction) {
            AddTransactionView(wallet: wallet) { tx in
                context.insert(tx)
                try? context.save()
            }
        }
        
        // 🔹 Редактировать транзакцию
        .sheet(item: $selectedTransaction) { tx in
            EditTransactionView(transaction: tx)
        }
        
        // 🔹 Floating "+"
        .overlay(alignment: .bottomTrailing) {
            Button(action: { showAddTransaction = true }) {
                Image(systemName: "plus")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 60, height: 60)
                    .background(Color.green)
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.25), radius: 6, x: 0, y: 4)
            }
            .padding()
        }
    }
}
