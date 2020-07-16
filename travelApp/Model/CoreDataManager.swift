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

    func loadItems(containing text: String? = nil) -> [Rate] {
        let request: NSFetchRequest<Rate> = Rate.fetchRequest()

        if let text = text {
            request.predicate = NSPredicate(format: "currency CONTAINS[cd] %@", text)
        }

        guard let items = try? context.fetch(request) else { return [] }
        return items
    }

    func deleteItems() {
        loadItems().forEach { context.delete($0)}
        coreDataStack.saveContext()
    }

    func deleteItems(items: [Rate]) {
        items.forEach { context.delete($0) }
        coreDataStack.saveContext()
    }

    func createItem(currency: String, rate: Double) {
        let newItem = Rate(context: context)
        newItem.currency = currency
        newItem.rate = rate
        coreDataStack.saveContext()
    }
}
