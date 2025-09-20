import SwiftUI

struct BalanceCardView: View {
    var walletName: String
    var balance: Decimal
    var currency: String
    var colorHex: String
    
    var body: some View {
        ZStack {
            // Фон карточки
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color(hex: colorHex))
                .overlay(
                    LinearGradient(
                        colors: [.white.opacity(0.25), .clear],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                )
                .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
            
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text(walletName)
                        .font(.headline)
                        .foregroundColor(.white)
                    Spacer()
                    Image(systemName: "creditcard.fill")
                        .foregroundColor(.white.opacity(0.8))
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(balance, format: .currency(code: currency))
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    Text(currency)
                        .font(.subheadline.weight(.medium))
                        .foregroundColor(.white.opacity(0.8))
                }
                
                Spacer()
                
                Text("Current Balance")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding(20)
        }
        .frame(maxWidth: .infinity, maxHeight: 180)
    }
}
