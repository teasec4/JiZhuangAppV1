//
//  CategoryPickerView.swift
//  JiZhuangAppV1
//
//  Created by Максим Ковалев on 9/13/25.
//

import SwiftUI
import SwiftData

struct CategoryPickerView: View {
    @Environment(\.dismiss) private var dismiss
    @Query private var categories: [Category]
    
    var isIncome: Bool
    var user: User            // 👈 теперь обязателен
    @Binding var selectedCategory: Category?
    
    @State private var showCreate = false
    
    var body: some View {
        List {
            ForEach(categories.filter { $0.isIncome == isIncome && $0.user == user }) { category in
                HStack {
                    Text(category.emoji)
                    Text(category.name)
                    Spacer()
                    if category == selectedCategory {
                        Image(systemName: "checkmark")
                            .foregroundColor(.blue)
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    selectedCategory = category
                    dismiss()
                }
            }
            // 🔹 Пункт "Создать категорию"
            HStack {
                Image(systemName: "plus.circle.fill")
                    .foregroundColor(.blue)
                Text("Create new category")
                    .foregroundColor(.blue)
                Spacer()
            }
            .contentShape(Rectangle())
            .onTapGesture {
                showCreate = true
            }
        }
        .navigationTitle(isIncome ? "Income categories" : "Expense categories")
        
        .sheet(isPresented: $showCreate) {
            NavigationStack {
                CreateCategoryView(user: user)   // 👈 user пробрасывается сюда
            }
        }
    }
}
