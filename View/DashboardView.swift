//
//  DashboardView.swift
//  JiZhuangAppV1
//
//  Created by Максим Ковалев on 9/13/25.
//

import SwiftUI
import SwiftData
import Foundation

import SwiftUI
import SwiftData
import Foundation

struct DashboardView: View {
    @Environment(\.modelContext) private var context
    @Query private var wallets: [Wallet]   // 👈 теперь получаем все кошельки
    @Query private var users: [User]
    
    @State private var showAddTransaction = false
    @State private var selectedTransaction: Transaction?
    @State private var selectedWalletIndex: Int = 0
    @State private var showCreateWallet = false
    
    private var vm: TransactionViewModel {
        TransactionViewModel(context: context)
    }
    
    private var selectedWallet: Wallet? {
        guard wallets.indices.contains(selectedWalletIndex) else { return nil }
        return wallets[selectedWalletIndex]
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                // 🔹 Карусель кошельков
                TabView(selection: $selectedWalletIndex) {
                    ForEach(Array(wallets.enumerated()), id: \.offset) { index, wallet in
                        BalanceCardView(
                            walletName: wallet.name,
                            balance: wallet.balance,
                            currency: "￥"
                        )
                        .padding(.horizontal)
                        .tag(index)
                    }
                    
                    // 🔹 Карточка "Создать кошелёк"
                    CreateWalletCardView()
                        .tag(wallets.count)
                        .onTapGesture {
                            showCreateWallet = true
                        }
                }
                .frame(height: 200)
                .tabViewStyle(.page(indexDisplayMode: .always))
                
                // 🔹 Список транзакций
                // 🔹 Список транзакций или заглушка
                if let wallet = selectedWallet {
                    if wallet.transactions.isEmpty {
                        // 🔹 Заглушка при отсутствии транзакций
                        VStack(spacing: 12) {
                            Image(systemName: "tray")
                                .font(.system(size: 40))
                                .foregroundColor(.secondary)
                            Text("Don't have any transaction")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            Text("Create your first transaction")
                                .font(.subheadline)
                                .foregroundColor(.secondary.opacity(0.7))
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding()
                    } else {
                        // 🔹 Список транзакций
                        List {
                            ForEach(wallet.transactions.sorted(by: { $0.date > $1.date })) { tx in
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
                        }
                        .listStyle(.plain)
                        .scrollContentBackground(.hidden)
                    }
                } else {
                    Spacer()
                    Text("Swipe to create your first wallet 👉")
                        .foregroundColor(.secondary)
                        .padding()
                }
            }
            .navigationTitle("Dashboard")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showAddTransaction) {
                if let wallet = selectedWallet {
                    AddTransactionView(wallet: wallet) { tx in
                        vm.addTransaction(amount: tx.amount,
                                          note: tx.note,
                                          isIncome: tx.isIncome,
                                          category: tx.category,
                                          wallet: tx.wallet)
                    }
                }
            }
            .sheet(item: $selectedTransaction) { tx in
                EditTransactionView(transaction: tx)
            }
            .sheet(isPresented: $showCreateWallet) {
                if let user = users.first {
                    NavigationStack {
                        CreateWalletView(user: user)
                    }
                }
            }
            .overlay(alignment: .bottomTrailing) {
                if selectedWallet != nil {
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
    }
}
