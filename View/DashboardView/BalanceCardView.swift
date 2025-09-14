import SwiftUI

struct BalanceCardView: View {
    @Environment(\.colorScheme) private var colorScheme
    
    var walletName: String
    var balance: Decimal
    var currency: String
    
    var body: some View {
        ZStack {
            // 🌈 Glow фон (разный для темной и светлой тем)
            if colorScheme == .dark {
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [Color.blue, Color.purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .blur(radius: 15)
                    .opacity(0.4)
            } else {
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [Color.blue.opacity(0.15), Color.purple.opacity(0.15)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .blur(radius: 15)
                    .opacity(0.4)
            }
            
            // 💳 Карта
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .stroke(Color.white.opacity(colorScheme == .dark ? 0.35 : 0.15),
                                lineWidth: colorScheme == .dark ? 1.5 : 1)
                )
                .shadow(color: .black.opacity(colorScheme == .dark ? 0.3 : 0.1),
                        radius: 10, x: 0, y: 6)
                .overlay(
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text(walletName)
                                .font(.headline)
                                .foregroundColor(colorScheme == .dark ? .white.opacity(0.95) : .primary)
                            Spacer()
                            Image(systemName: "creditcard.fill")
                                .foregroundColor(colorScheme == .dark ? .white.opacity(0.9) : .primary)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("\(balance, format: .number)")
                                .font(.system(size: 34, weight: .bold, design: .rounded))
                                .foregroundColor(colorScheme == .dark ? .white : .primary)
                            
                            Text(currency)
                                .font(.subheadline.weight(.medium))
                                .foregroundColor(colorScheme == .dark ? .white.opacity(0.85) : .secondary)
                        }
                        
                        Spacer()
                        
                        Text("Current Balance")
                            .font(.caption)
                            .foregroundColor(colorScheme == .dark ? .white.opacity(0.75) : .secondary)
                    }
                    .padding(20)
                )
        }
        .frame(maxWidth: .infinity, maxHeight: 180)
    }
}

#Preview {
    Group {
        BalanceCardView(walletName: "WeChat Wallet", balance: 1532.75, currency: "USD")
            .padding()
            .background(Color.black.ignoresSafeArea())
            .preferredColorScheme(.dark)
        
        BalanceCardView(walletName: "WeChat Wallet", balance: 1532.75, currency: "USD")
            .padding()
            .background(Color.white.ignoresSafeArea())
            .preferredColorScheme(.light)
    }
}
