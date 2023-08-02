//
//  NoconRouletteApp.swift
//  NoconRoulette
//
//  Created by 金子広樹 on 2023/08/01.
//

import SwiftUI

@main
struct NoconRouletteApp: App {
    let persistenceController = PersistenceController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
