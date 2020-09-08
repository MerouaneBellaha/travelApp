//
//  CoreDataManager.swift
//  travelApp
//
//  Created by Merouane Bellaha on 15/07/2020.
//  Copyright © 2020 Merouane Bellaha. All rights reserved.
//

import CoreData

enum Predicate {
    case currency(String)
    case text(String)

    var format: NSPredicate {
        switch self {
        case .currency(let currency):
            return NSPredicate(format: K.currencyFormat, currency)
        case .text(let text):
            return NSPredicate(format: K.taskFormat, text)
        }
    }
}


final class CoreDataManager {

    // MARK: - Properties

    private var context: NSManagedObjectContext
    private var coreDataStack: CoreDataStack

    // MARK: - Init

    init(with coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
        self.context = coreDataStack.context
    }

    // MARK: - Methods

    func loadItems<T: NSManagedObject>(entity: T.Type, predicate: Predicate? = nil, sortBy key: String? = nil) -> [T] {
        let request = T.fetchRequest()

        if let predicate = predicate {
            request.predicate = predicate.format
        }
        if let key = key {
            request.sortDescriptors = [NSSortDescriptor(key: key, ascending: true)]
        }

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
