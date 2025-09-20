import SwiftUI
import SwiftData

struct CreateCategoryView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    var user: User
    @Binding var isIncome: Bool                // 👈 одно состояние извне
    var onCreate: (Category) -> Void
    
    @State private var name: String = ""
    @State private var selectedEmoji: String = "❓"
    
    private let emojis = ["🍔","🛒","🚌","💻","🎉","📚","💡","🏠","🏦","❤️","🎮","✈️","👕","🛠️","🍹"]
    
    // в CreateCategoryView
    private func saveCategory() {
//        let finalIsIncome = presetIsIncome   // жёсткий флаг, который мы пробросили извне


        let category = Category(
            name: name,
            emoji: selectedEmoji,
            isIncome: isIncome,
            user: user
        )

        context.insert(category)
        do {
            try context.save()
            print("[CreateCategory] saved category id=\(category.id) isIncome=\(category.isIncome) userId=\(category.user.id)")
        } catch {
            print("[CreateCategory] save error:", error)
        }

        onCreate(category)
        dismiss()
    }
    
    var body: some View {
        Form {
            Section("Basic Info") {
                TextField("Category name", text: $name)
            }
            
            Section("Emoji") {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 6)) {
                    ForEach(emojis, id: \.self) { emoji in
                        Text(emoji)
                            .font(.title2)
                            .frame(width: 44, height: 44)
                            .background(
                                Circle().fill(selectedEmoji == emoji ? Color.blue.opacity(0.2) : .clear)
                            )
                            .overlay(
                                Circle().stroke(selectedEmoji == emoji ? .blue : .gray.opacity(0.3), lineWidth: 2)
                            )
                            .onTapGesture { selectedEmoji = emoji }
                    }
                }
                .padding(.vertical, 4)
            }
        }
        .navigationTitle(isIncome ? "New Income Category" : "New Expense Category")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") { dismiss() }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Save", action: saveCategory)
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
            }
        }
    }
}
