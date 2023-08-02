//
//  Data.swift
//  NoconRoulette
//
//  Created by 金子広樹 on 2023/08/01.
//

import SwiftUI
import CoreData

struct PersistenceController {
    let container: NSPersistentContainer
    
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for num in 0..<5 {
            let newItem = Entity(context: viewContext)
            newItem.title = "Title\(num + 1)"
            newItem.createDate = Date().addingTimeInterval(Double(num))
            newItem.number = Int16(num + 1)
        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Model")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
}
