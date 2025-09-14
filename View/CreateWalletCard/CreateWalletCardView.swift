//
//  CreateWalletCardView.swift
//  JiZhuangAppV1
//
//  Created by Максим Ковалев on 9/14/25.
//

import SwiftUI

struct CreateWalletCardView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color(.systemGray6))
                .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 4)
            
            VStack(alignment: .center, spacing: 12) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 40, weight: .semibold))
                    .foregroundColor(.blue)
                Text("Create new wallet")
                    .font(.headline)
                    .foregroundColor(.blue)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 180) // 🔹 одинаковая высота
        .padding(.horizontal)
    }
}
