//
//  TestPersistenceController.swift
//  PerqaraTestTests
//
//  Created by Andi Septiadi on 17/08/23.
//

import Foundation
import CoreData

struct TestPersistenceController {
    let container: NSPersistentContainer
    
    var viewContext: NSManagedObjectContext {
        container.viewContext
    }
    
    init(modelName: String) {
        container = NSPersistentContainer(name: modelName)
        container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func save() throws {
        guard viewContext.hasChanges else { return }
        do {
            try viewContext.save()
        } catch {
            throw error
        }
    }
    
    func delete(_ object: NSManagedObject) throws {
        viewContext.delete(object)
        try viewContext.save()
    }
}
