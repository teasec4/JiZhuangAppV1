//
//  CreateWalletView.swift
//  JiZhuangAppV1
//
//  Created by Максим Ковалев on 9/13/25.
//
import SwiftUI
import SwiftData

struct CreateWalletView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @Query private var users: [User]

    @State private var name: String = ""
    @State private var balance: Decimal = 0

    var body: some View {
        VStack(spacing: 24) {
            Text("Create your Wallet")
                .font(.title2.bold())
                .padding(.top, 40)
            
            VStack(spacing: 16) {
                TextField("Wallet name", text: $name)
                    .textFieldStyle(.roundedBorder)
                
                TextField("Starting balance", value: $balance, format: .number)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(.roundedBorder)
            }
            .padding(.horizontal)

            Spacer()

            Button {
                if let user = users.first {
                    let wallet = Wallet(
                        name: name.isEmpty ? "My Wallet" : name,
                        balance: balance,
                        user: user
                    )
                    context.insert(wallet)
                    try? context.save()
                    dismiss()
                }
            } label: {
                Text("Create Wallet")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(name.isEmpty ? Color.gray : Color.blue)
                    .cornerRadius(12)
            }
            .disabled(name.isEmpty)
            .padding(.horizontal)
            .padding(.bottom, 40)
        }
    }
}
