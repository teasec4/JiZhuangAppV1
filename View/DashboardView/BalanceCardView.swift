//
//  BalanceCard.swift
//  JiZhuangAppV1
//
//  Created by Максим Ковалев on 9/13/25.
//

import SwiftUI

import SwiftUI

struct BalanceCardView: View {
    var walletName: String
    var balance: Decimal
    var currency: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(walletName)
                .font(.headline)
                .foregroundColor(.white.opacity(0.8))
            
            Text("\(balance, format: .number) \(currency)")
                .font(.largeTitle.bold())
                .foregroundColor(.white)
            
            Spacer()
            
            Text("Current Balance")
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: 200)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.gray, Color.yellow]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
    }
}

#Preview {
    BalanceCardView(walletName :"WeChat", balance : 100, currency: "USD")
        .frame(height: 150)
        .padding()
}
