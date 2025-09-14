//
//  ContentView.swift
//  JiZhuangAppV1
//
//  Created by Максим Ковалев on 9/13/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var context
    @Query private var wallets: [Wallet]
    @Query private var users: [User]
    
    @State private var showProfile = false
    
    var body: some View {
        Group {
            if users.isEmpty {
                // 👤 если нет юзера → регистрация
                RegisterView {
                    // после регистрации SwiftData сам обновит @Query
                }
            } else {
                // 📊 если юзер есть → основное приложение
                ZStack{
                    TabView {
                        NavigationStack {
                            if wallets.isEmpty {
                                // нет кошельков — предлагаем создать
                                CreateWalletView(user: users[0])
                            } else {
                                // ⚠️ НОВЫЙ DashboardView без параметров
                                DashboardView()
                            }
                        }
                        
                        .tabItem {
                            Label("Home", systemImage: "house.fill")
                        }
                        
                        NavigationStack {
                            TransactionsView()
                        }
                        
                        .tabItem {
                            Label("Transactions", systemImage: "list.bullet")
                        }
                        
                        NavigationStack {
                            StatisticsView()
                        }
                        
                        .tabItem {
                            Label("Statistics", systemImage: "chart.pie.fill")
                        }
                    }
                    // 🔹 плавающая кнопка профиля (ТОЛЬКО после регистрации)
                    VStack {
                        HStack {
                            Spacer()
                            Button {
                                showProfile = true
                            } label: {
                                if let user = users.first {
                                    Circle()
                                        .fill(Color.blue.opacity(0.2))
                                        .frame(width: 36, height: 36)
                                        .overlay(
                                            Text(String(user.name.prefix(1)))
                                                .font(.headline)
                                                .foregroundColor(.blue)
                                        )
                                } else {
                                    Image(systemName: "person.circle.fill")
                                        .font(.system(size: 32))
                                        .foregroundColor(.blue)
                                }
                            }
                            .padding(.trailing, 16)
                            
                        }
                        Spacer()
                    }
                }
                .sheet(isPresented: $showProfile) {
                    ProfileView()
                }
            }
        }
    }
}
