//
//  ProfileView.swift
//  JiZhuangAppV1
//
//  Created by Максим Ковалев on 9/14/25.
//

import SwiftUI
import SwiftData

struct ProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @Query private var users: [User]
    
    var body: some View {
        NavigationStack {
            Form {
                if let user = users.first {
                    Section("Account") {
                        HStack(spacing: 12) {
                            // Аватар
                            Circle()
                                .fill(Color.blue.opacity(0.2))
                                .frame(width: 50, height: 50)
                                .overlay(
                                    Text(String(user.name.prefix(1)))
                                        .font(.title)
                                        .foregroundColor(.blue)
                                )
                            
                            VStack(alignment: .leading) {
                                Text(user.name)
                                    .font(.headline)
                                Text("ID: \(user.persistentModelID)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                
                Section("Preferences") {
                    Toggle("Dark Mode", isOn: .constant(false))
                    Toggle("Notifications", isOn: .constant(true))
                }
            }
            .navigationTitle("Profile")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }
}
