//
//  CoreDataManager.swift
//  travelApp
//
//  Created by Merouane Bellaha on 15/07/2020.
//  Copyright © 2020 Merouane Bellaha. All rights reserved.
//

import CoreData

final class CoreDataManager {
    var context: NSManagedObjectContext
    var coreDataStack: CoreDataStack

    init(with coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
        self.context = coreDataStack.context
    }

    func loadItems<T: NSManagedObject>(entity: T.Type, currency: String? = nil, text: String? = nil) -> [T] {
        let request = T.fetchRequest()

        if let currency = currency {
            request.predicate = NSPredicate(format: "currency CONTAINS[cd] %@", currency)
        }
        if let text = text {
            request.predicate = NSPredicate(format: "taskName CONTAINS[cd] %@", text)
        }
        
//        request.sortDescriptors = [NSSortDescriptor(key: "taskName", ascending: true)]

        guard let items = try? (context.fetch(request).compactMap { $0 as? T }) else { return [] }
        return items
    }

    func createItem<T: NSManagedObject>(entity: T.Type, callBack: @escaping ((T) -> ())) {
        let newItem = T(context: context)
        callBack(newItem)
        coreDataStack.saveContext()
    }

    func deleteItems<T: NSManagedObject>(entity: T.Type) {
        loadItems(entity: entity).forEach { context.delete($0)}
        coreDataStack.saveContext()
    }

    func deleteItem<T: NSManagedObject>(item: T) {
        context.delete(item)
        coreDataStack.saveContext()
    }

}
