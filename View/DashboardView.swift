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
            ScrollView {
                LazyVStack(spacing: 16) {
                    
                    // 🔹 Список кошельков
                    ForEach(wallets, id: \.id) { wallet in
                        NavigationLink(destination: WalletDetailView(wallet: wallet)) {
                            WalletRowView(wallet: wallet)
                                .padding(.horizontal)
                        }
                    }
                    
                    // 🔹 Строка "Создать кошелёк"
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
                            .padding()
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.top, 12)
            }
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
