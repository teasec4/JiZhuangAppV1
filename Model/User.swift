//
//  User.swift
//  JiZhuangAppV1
//
//  Created by Максим Ковалев on 9/13/25.
//
import Foundation
import SwiftData

@Model
final class User {
    @Attribute(.unique) var id: UUID
    var name: String
    
    // Связь: у юзера может быть несколько кошельков
    @Relationship(deleteRule: .cascade, inverse: \Wallet.user)
    var wallets: [Wallet] = []
    
    @Relationship(deleteRule: .cascade, inverse: \Category.user)
    var categories: [Category] = []
    
    init(name: String) {
        self.id = UUID()
        self.name = name
    }
}
