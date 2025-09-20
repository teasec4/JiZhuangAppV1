//
//  DashboardView.swift
//  JiZhuangAppV1
//
//  Created by Максим Ковалев on 9/13/25.
//

import SwiftUI
import SwiftData

struct DashboardView: View {
    @Environment(\.modelContext) private var context
    @Query private var wallets: [Wallet]
    @Query private var users: [User]
    
    @State private var showCreateWallet = false
    
    var body: some View {
        NavigationStack {
            List {
                // 🔹 Список кошельков
                ForEach(wallets, id: \.id) { wallet in
                    NavigationLink(destination: WalletDetailView(wallet: wallet)) {
                        WalletRowView(wallet: wallet)
                        
                    }
                }
                .onDelete(perform: deleteWallets)
                
                // 🔹 Строка "Создать кошелёк"
                // Навигация на форму создания
                if let user = users.first {
                    NavigationLink {
                        CreateWalletView(user: user)
                    } label: {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                                .font(.title2)
                                .foregroundColor(.blue)
                            Text("Create Wallet")
                                .font(.headline)
                                .foregroundColor(.blue)
                            Spacer()
                        }
                        .padding(.vertical, 6)
                    }
                }
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .navigationTitle("Dashboard")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showCreateWallet) {
                if let user = users.first {
                    NavigationStack {
                        CreateWalletView(user: user)
                    }
                }
            }
        }
    }
    
    private func deleteWallets(at offsets: IndexSet) {
        offsets.map { wallets[$0] }.forEach(context.delete)
        try? context.save()
    }
}
