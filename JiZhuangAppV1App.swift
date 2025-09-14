//
//  JiZhuangAppV1App.swift
//  JiZhuangAppV1
//
//  Created by Максим Ковалев on 9/13/25.
//

import SwiftUI
import SwiftData

@main
struct JiZhuangAppV1App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for:[Category.self, Transaction.self, Wallet.self, User.self])
    }
}
