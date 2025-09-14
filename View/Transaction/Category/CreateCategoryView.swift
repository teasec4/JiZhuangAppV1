//
//  CreateCategoryView.swift
//  JiZhuangAppV1
//
//  Created by Максим Ковалев on 9/14/25.
//

import SwiftUI
import SwiftData

import SwiftUI
import SwiftData

struct CreateCategoryView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    var user: User   // 👈 передаём текущего юзера
    
    @State private var name: String = ""
    @State private var selectedEmoji: String = "❓"
    @State private var isIncome: Bool = false
    
    private let emojis = ["🍔","🛒","🚌","💻","🎉","📚","💡","🏠","🏦","❤️","🎮","✈️","👕","🛠️","🍹"]
    
    private var canSave: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    private func saveCategory() {
        let category = Category(
            name: name,
            emoji: selectedEmoji,
            isIncome: isIncome,
            user: user
        )
        context.insert(category)
        try? context.save()
        dismiss()
    }
    
    var body: some View {
        Form {
            Section("Basic Info") {
                TextField("Category name", text: $name)
            }
            
            Section("Emoji") {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 6), spacing: 12) {
                    ForEach(emojis, id: \.self) { emoji in
                        Text(emoji)
                            .font(.title2)
                            .frame(width: 44, height: 44)
                            .background(
                                Circle()
                                    .fill(selectedEmoji == emoji ? Color.blue.opacity(0.2) : Color.clear)
                            )
                            .overlay(
                                Circle()
                                    .stroke(selectedEmoji == emoji ? Color.blue : Color.gray.opacity(0.3), lineWidth: 2)
                            )
                            .onTapGesture {
                                selectedEmoji = emoji
                            }
                    }
                }
                .padding(.vertical, 4)
            }
            
            Section("Type") {
                Picker("Category type", selection: $isIncome) {
                    Text("Expense").tag(false)
                    Text("Income").tag(true)
                }
                .pickerStyle(.segmented)
            }
        }
        .navigationTitle("New Category")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") { dismiss() }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Save", action: saveCategory)
                    .disabled(!canSave)
            }
        }
    }
}
