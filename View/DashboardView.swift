//
//  DashboardView.swift
//  JiZhuangAppV1
//
//  Created by Максим Ковалев on 9/13/25.
//

import SwiftUI
import SwiftData
import Foundation

struct DashboardView: View {
    @Environment(\.modelContext) private var context
    @State private var showAddTransaction = false
    @State private var selectedTransaction: Transaction?
    
    
    var wallet: Wallet
    
    
    private var vm: TransactionViewModel {
        TransactionViewModel(context: context)
    }
    
    
    var body: some View {
        ZStack{
            VStack(spacing:12){
                BalanceCardView(walletName: wallet.name, balance:wallet.balance, currency: "USD")
                    .padding(.horizontal)
                
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
            VStack{
                Spacer()
                HStack{
                    Spacer()
                    Button(action:{
                        showAddTransaction = true
                    } ) {
                        Image(systemName: "plus")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 60, height: 60)
                            .background(Color.green)
                            .clipShape(Circle())
                            .shadow(color: .black.opacity(0.25), radius: 6, x: 0, y: 4)
                    }
                }
                .padding()
            }
        }
        .navigationTitle(Text("Dashboard"))
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showAddTransaction) {
            AddTransactionView(wallet: wallet) { tx in
                vm.addTransaction(amount: tx.amount,
                                  note: tx.note,
                                  isIncome: tx.isIncome,
                                  category: tx.category,
                                  wallet: tx.wallet)
            }
        }
        .sheet(item: $selectedTransaction) { tx in
            EditTransactionView(transaction: tx)
        }
        
    }
}


