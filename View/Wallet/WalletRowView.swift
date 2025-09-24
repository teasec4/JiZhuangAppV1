import SwiftUI

struct WalletRowView: View {
    var wallet: Wallet
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color(hex: wallet.colorHex))
                .overlay(
                    LinearGradient(
                        colors: [.white.opacity(0.25), .clear],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                )
                .shadow(color: .black.opacity(0.15), radius: 6, x: 0, y: 3)
            
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text(wallet.name)
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Text("\(wallet.transactions.count) transactions")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                }
                
                Spacer()
                
                Text(formatBalance(wallet.balance, currency: "CNY"))
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
            }
            .padding()
        }
        .frame(maxWidth: .infinity, minHeight: 100)
             
    }
    
    private func formatBalance(_ value: Decimal, currency: String) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currency
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        return formatter.string(from: value as NSDecimalNumber) ?? "\(value)"
    }
}
