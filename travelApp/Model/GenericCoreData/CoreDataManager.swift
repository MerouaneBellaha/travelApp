//
//  CoreDataManager.swift
//  travelApp
//
//  Created by Merouane Bellaha on 15/07/2020.
//  Copyright © 2020 Merouane Bellaha. All rights reserved.
//

import CoreData

final class CoreDataManager {

    // MARK: - Properties

    var context: NSManagedObjectContext
    var coreDataStack: CoreDataStack

    // MARK: - Init

    init(with coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
        self.context = coreDataStack.context
    }

    // MARK: - Methods

    func loadItems<T: NSManagedObject>(entity: T.Type, currency: String? = nil, text: String? = nil) -> [T] {
        let request = T.fetchRequest()

        // Must be refacto
        if let currency = currency {
            request.predicate = NSPredicate(format: K.currencyFormat, currency)
        }
        if let text = text {
            request.predicate = NSPredicate(format: K.taskFormat, text)
        }
        if T.self == Task.self {
            request.sortDescriptors = [NSSortDescriptor(key: K.taskName, ascending: true)]
        } else if T.self == Rate.self {
            request.sortDescriptors = [NSSortDescriptor(key: K.currency, ascending: true)]
        }
        // --

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
