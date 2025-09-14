//
//  Shimme.swift
//  JiZhuangAppV1
//
//  Created by Максим Ковалев on 9/14/25.
//
import SwiftUI

struct Shimmer: ViewModifier {
    @State private var phase: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .overlay(
                LinearGradient(
                    colors: [
                        Color.white.opacity(0.0),
                        Color.white.opacity(0.4),
                        Color.white.opacity(0.0)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .rotationEffect(.degrees(30))
                .offset(x: phase * 350)
                .blendMode(.plusLighter)
            )
            .mask(content)
            .onAppear {
                withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                    phase = 1
                }
            }
    }
}

extension View {
    func shimmer() -> some View {
        modifier(Shimmer())
    }
}
