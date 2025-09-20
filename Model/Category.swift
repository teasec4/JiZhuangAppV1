//
//  Category.swift
//  JiZhuangAppV1
//
//  Created by Максим Ковалев on 9/13/25.
//
import Foundation
import SwiftData

@Model
final class Category {
    @Attribute(.unique) var id: UUID
    var name: String
    var emoji: String
    var isIncome: Bool   // ✅ новое поле

    var user: User

   
    var transactions: [Transaction] = []

    init(name: String, emoji: String, isIncome: Bool, user: User) {
        self.id = UUID()
        self.name = name
        self.emoji = emoji
        self.isIncome = isIncome
        self.user = user
    }
}
