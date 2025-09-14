import SwiftUI

struct BalanceCardView: View {
    @Environment(\.colorScheme) private var colorScheme
    
    var walletName: String?
    var balance: Decimal?
    var currency: String?
    
    private var isPlaceholder: Bool {
        walletName == nil || balance == nil || currency == nil
    }
    
    var body: some View {
        ZStack {
            // 🌈 Glow фон
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: colorScheme == .dark
                        ? [Color.blue, Color.purple]
                        : [Color.blue.opacity(0.15), Color.purple.opacity(0.15)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .blur(radius: 15)
                .opacity(0.4)
            
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
                    Group {
                        if isPlaceholder {
                            VStack(alignment: .leading, spacing: 16) {
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(width: 80, height: 16)
                                    .shimmer()
                                
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(width: 140, height: 28)
                                    .shimmer()
                                
                                Spacer()
                                
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color.gray.opacity(0.2))
                                    .frame(width: 100, height: 12)
                                    .shimmer()
                            }
                            .padding(20)
                        } else {
                            VStack(alignment: .leading, spacing: 16) {
                                HStack {
                                    Text(walletName!)
                                        .font(.headline)
                                    Spacer()
                                    Image(systemName: "creditcard.fill")
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("\(balance!, format: .number)")
                                        .font(.system(size: 34, weight: .bold, design: .rounded))
                                    Text(currency!)
                                        .font(.subheadline.weight(.medium))
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                                
                                Text("Current Balance")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .padding(20)
                        }
                    }
                )
        }
        .frame(maxWidth: .infinity, maxHeight: 180)
    }
}
