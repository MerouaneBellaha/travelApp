//
//  travelAppTests.swift
//  travelAppTests
//
//  Created by Merouane Bellaha on 18/07/2020.
//  Copyright © 2020 Merouane Bellaha. All rights reserved.
//

import XCTest
@testable import travelApp

class CoreDataManagerTest: XCTestCase {

    var coreDataStack: CoreDataStack!
    var coreDataManager: CoreDataManager!

    override func setUp() {
        super.setUp()
        coreDataStack = FakeCoreDataStack()
        coreDataManager = CoreDataManager(with: coreDataStack)
    }

    override func tearDown() {
        super.tearDown()
        coreDataStack = nil
        coreDataManager = nil
    }

    func testGivenCoreDataManagerIsEmpty_WhenCreateAnItem_ThenCoreDataManagerShouldHaveOneItemNamedATask() {
        coreDataManager.createItem(entity: Task.self) { $0.taskName = "A task" }

        XCTAssertTrue(coreDataManager.loadItems(entity: Task.self).count == 1)
        XCTAssertTrue(coreDataManager.loadItems(entity: Task.self).first?.taskName == "A task")
    }

    func testGivenCoreDataManagerContainsMoreThanOneItem_WhenDeleteAllItems_ThenCoreDataManagerShouldBeEmpty() {
        coreDataManager.createItem(entity: Task.self) { $0.taskName = "A task" }
        coreDataManager.createItem(entity: Task.self) { $0.taskName = "A task 2" }

        coreDataManager.deleteItems(entity: Task.self)

        XCTAssertTrue(coreDataManager.loadItems(entity: Task.self).isEmpty)
    }

    func testGivenCoreDataManagerContainsMoreThanOneItem_WhenDeleteOneSpecificItem_ThenCoreDataManagerShouldNotContainTheDeletedItem() {
        coreDataManager.createItem(entity: Task.self) { $0.taskName = "A task" }
        coreDataManager.createItem(entity: Task.self) { $0.taskName = "A task 2" }

        guard let targetItem = coreDataManager.loadItems(entity: Task.self).first(where: { $0.taskName == "A task 2"}) else { return }

        coreDataManager.deleteItem(item: targetItem)

        XCTAssertFalse(coreDataManager.loadItems(entity: Task.self).contains(targetItem))
        XCTAssertTrue(coreDataManager.loadItems(entity: Task.self).count == 1)
    }



}
