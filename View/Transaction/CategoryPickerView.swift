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
    @Binding var selectedCategory: Category?
    
    var body: some View {
        List {
            ForEach(categories.filter { $0.isIncome == isIncome }) { category in
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
        }
        .navigationTitle(isIncome ? "Income categories" : "Expense categories")
    }
}
