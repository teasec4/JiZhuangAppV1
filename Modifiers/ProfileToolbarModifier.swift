//
//  ProfileToolbarModifier.swift
//  JiZhuangAppV1
//

import SwiftUI
import SwiftData

struct ProfileToolbarModifier: ViewModifier {
    @Binding var showProfile: Bool
    @Query private var users: [User]
    
    func body(content: Content) -> some View {
        content.toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showProfile = true
                } label: {
                    if let user = users.first {
                        // маленький аватар с инициалом
                        Circle()
                            .fill(Color.blue.opacity(0.2))
                            .frame(width: 28, height: 28)
                            .overlay(
                                Text(String(user.name.prefix(1)))
                                    .font(.caption)
                                    .foregroundColor(.blue)
                            )
                    } else {
                        // fallback иконка
                        Image(systemName: "person.circle")
                            .imageScale(.large)
                    }
                }
            }
        }
    }
}

extension View {
    func profileToolbar(showProfile: Binding<Bool>) -> some View {
        self.modifier(ProfileToolbarModifier(showProfile: showProfile))
    }
}
